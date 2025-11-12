import { common } from '@kit.AbilityKit'
import { RDBStoreUtil } from '../common/database/RDBStoreUtil'

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext
  rdbStoreUtil: RDBStoreUtil = new RDBStoreUtil(this.context)

  build() {
    Column() {
      Button('创建表')
        .onClick(() => {
          let sql = `CREATE TABLE IF NOT EXISTS student(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );`
          this.rdbStoreUtil.executeSQL(sql)
        })
    }
    .width('100%')
    .height('100%')
  }
}