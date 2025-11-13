import { relationalStore, ValuesBucket } from "@kit.ArkData";
import { BusinessError } from '@kit.BasicServicesKit'
import { Student } from "../../domain/Student";

let rdbStore: relationalStore.RdbStore

/**
 * 数据库工具类
 *
 * @author 小生化
 * @date 2025/11/12 16:42
 */
export class RDBStoreUtil {
  /**
   * 创建数据库（构造器的写法）
   */
  constructor(context: Context, dbName: string = 'rdbStore') {
    const config: relationalStore.StoreConfig = { name: dbName, securityLevel: relationalStore.SecurityLevel.S1 }
    relationalStore.getRdbStore(context, config, (err, store) => {
      if (err) {
        console.error(`数据库创建失败，code is ${err.code}, message is ${err.message}`)
        return
      }
      console.info('创建数据库成功。')
      rdbStore = store
    })
  }

  /**
   * 执行语句
   */
  executeSQL(sql: string): void {
    rdbStore.executeSql(sql, (err: BusinessError) => {
      if (err) {
        console.error(`执行失败，code is ${err.code}, message is ${err.message}`)
        return
      }
      console.info('SQL语句执行成功。')
    })
  }

  /**
   * 新增
   */
  add(tableName: string, data: ValuesBucket) {
    rdbStore.insert(tableName, data, (err: BusinessError, rowId: number) => {
      if (err) {
        console.error(`新增失败，code is ${err.code}, message is ${err.message}`)
        return
      }
      console.info(`新增成功，rowId is ${rowId}`)
    })
  }

  /**
   * 查询
   */
  async list(tableName: string) {
    let predicates = new relationalStore.RdbPredicates(tableName)
    predicates.orderByAsc('id')
    let result = await rdbStore.query(predicates)
    let list: Array<Student> = []
    while (result.goToNextRow()) {
      list.push(result.getRow() as Student)
    }
    return list
  }

  /**
   * 删除
   */
  delete(tableName: string, id: number) {
    let predicates = new relationalStore.RdbPredicates(tableName)
    predicates.equalTo('id', id)
    rdbStore.delete(predicates, (err: BusinessError, rows: number) => {
      if (err) {
        console.error(`删除失败，code is ${err.code}, message is ${err.message}`)
        return
      }
      console.info(`删除成功，影响行数 is ${rows}`)
    })
  }

  /**
   * 条件查询
   */
  async queryId(tableName: string, id: string) {
    let predicates = new relationalStore.RdbPredicates(tableName)
    predicates.equalTo('id', id)
    let result = await rdbStore.query(predicates)
    let list: Array<Student> = []
    while (result.goToNextRow()) {
      list.push(result.getRow() as Student)
    }
    return list[0]
  }

  /**
   * 修改
   */
  updateName(tableName: string, id: string, name: string) {
    let predicates = new relationalStore.RdbPredicates(tableName)
    predicates.equalTo('id', id)
    let data: relationalStore.ValuesBucket = { name: name }
    rdbStore.update(data, predicates, (err: BusinessError, rows: number) => {
      if (err) {
        console.error(`修改失败，code is ${err.code}, message is ${err.message}`)
        return
      }
      console.info(`修改成功，影响行数 is ${rows}`)
    })
  }
}