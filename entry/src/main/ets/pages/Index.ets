import { common } from '@kit.AbilityKit'
import { RDBStoreUtil } from '../common/database/RDBStoreUtil'
import { ValuesBucket } from '@kit.ArkData'

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext
  rdbStoreUtil: RDBStoreUtil = new RDBStoreUtil(this.context)
  @State inputString: string = ''

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

    }
    .width('100%')
    .height('100%')
  }
}