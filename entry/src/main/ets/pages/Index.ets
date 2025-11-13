import { common } from '@kit.AbilityKit'
import { RDBStoreUtil } from '../common/database/RDBStoreUtil'
import { ValuesBucket } from '@kit.ArkData'
import { Student } from '../domain/Student'

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext
  rdbStoreUtil: RDBStoreUtil = new RDBStoreUtil(this.context)
  @State inputString: string = ''
  @State studentList: Student[] = []
  @State queryId: string = ''
  @State student: Student | null = null
  @State updateName: string = ''

  async listStudent() {
    this.studentList = await this.rdbStoreUtil.list('student')
  }

  async queryStudentById(id: string) {
    let result: Student = await this.rdbStoreUtil.queryId('student', id)
    if (result != null) {
      this.student = result
    }
  }

  build() {
    Column() {

      Button('创建表')
        .onClick(() => {
          let sql = `CREATE TABLE IF NOT EXISTS student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);`
          this.rdbStoreUtil.executeSQL(sql)
        })

      TextInput({ placeholder: '请输入名字', text: this.inputString })
        .onChange((value: string) => {
          this.inputString = value
        })

      Button('保存')
        .onClick(() => {
          let data: ValuesBucket = { name: this.inputString }
          this.rdbStoreUtil.add('student', data)
          this.inputString = ''
          setTimeout(() => {
            this.listStudent()
          }, 50)
        })

      Button('获取数据')
        .onClick(() => {
          this.listStudent()
        })

      List() {
        ForEach(this.studentList, (item: Student) => {
          ListItem() {
            Row({ space: 10 }) {
              Text(item.id.toString())
              Text(item.name)
              Button('删除')
                .backgroundColor(Color.Red)
                .onClick(() => {
                  this.rdbStoreUtil.delete('student', item.id)
                  setTimeout(() => {
                    this.listStudent()
                  }, 50)
                })
            }
            .width('100%')
          }
        })
      }
      .width('100%')
      .height('180vp')
      .border({ width: 1 })

      TextInput({ placeholder: '请输入要查询的学生id' })
        .onChange((value: string) => {
          this.queryId = value
        })

      Button('查询')
        .onClick(() => {
          this.queryStudentById(this.queryId)
        })

      Text('查询结果')
      Text(this.student?.id.toString())
      Text(this.student?.name)

      Text('修改数据')
      Text(this.student?.id.toString())
      TextInput({ placeholder: '修改', text: this.student?.name })
        .onChange((value: string) => {
          this.updateName = value
        })

      Button('修改')
        .onClick(() => {
          if (this.student != null) {
            this.rdbStoreUtil.updateName('student', this.student?.id.toString(), this.updateName)
          }
          setTimeout(() => {
            this.listStudent()
          }, 50)
        })
    }
    .width('100%')
    .height('100%')
  }
}