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

  async listStudent() {
    this.studentList = await this.rdbStoreUtil.list('student')
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
            }
            .width('100%')

          }
        })
      }
      .width('100%')
      .height('400vp')
      .border({ width: 1 })
    }
    .width('100%')
    .height('100%')
  }
}