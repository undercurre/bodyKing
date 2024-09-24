import { relationalStore } from '@kit.ArkData'
import { common } from '@kit.AbilityKit';
import { ColumnInfo, ColumnType } from '../viewmodel/ColumnInfo';

const DB_FILENAME: string = 'BodyKing.db'

class DBUtil {
  rdbStore: relationalStore.RdbStore | null = null;

  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          console.log('rdbStore 初始化完成')
          resolve()
        })
        .catch((reason: Error) => {
          console.log('rdbStore 初始化异常', JSON.stringify(reason))
          reject(reason)
        })
    });
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.executeSql(createSQL)
        .then(() => {
          console.log('成功创建表', createSQL)
          resolve()
        })
        .catch((err: Error) => {
          console.log('创建表失败', JSON.stringify(err))
          reject()
        })
    })
  }

  insert(tableName: string, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns)
      this.rdbStore?.insert(tableName, value, (err, id) => {
        if (err) {
          console.log('新增失败', JSON.stringify(err))
          reject(err)
        } else {
          console.log('新增成功，新增数据ID:' + id.toString())
          resolve(id)
        }
      })
    })
  }

  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.delete(predicates, (err, rows) => {
        if (err) {
          console.log('删除失败', JSON.stringify(err))
          reject(err)
        } else {
          console.log('删除成功，删除第' + rows.toString() + '行数据')
          resolve(rows)
        }
      })
    })
  }

  queryForList<T> (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
		return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          console.log('查询失败', JSON.stringify(err))
        } else {
          console.log('查询成功，查询到' + result.rowCount.toString() + ' 行')
          resolve(this.parseResultSet(result, columns))
        }
      })
    })
	}

  update(obj: object,  columns: ColumnInfo[], predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns)
      this.rdbStore?.update(value, predicates, (err, id) => {
        if (err) {
          console.log('修改失败', JSON.stringify(err))
          reject(err)
        } else {
          console.log('修改成功，修改数据的ID为：' + id)
          resolve(id)
        }
      })
    })
  }

  parseResultSet<T> (result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    let arr: Array<T> = []

    if (result.rowCount <= 0) {
      return arr
    }

    while (!result.isAtLastRow) {
      result.goToNextRow()
      let obj: Record<string, string | number | Uint8Array | null> = {}
      columns.forEach(info => {
        let val: string | number | Uint8Array | null = null
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName))
            break;
        }
        obj[info.name] = val
      })
      arr.push(obj as T);
      console.log('查询到的数据:' + JSON.stringify(obj))
    }
    return arr
  }

  buildValueBucket(obj: object, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    let value: relationalStore.ValuesBucket = {};
    columns.forEach(info => {
      if (typeof obj[info.name] !== 'undefined') {
        value[info.columnName] = obj[info.name]
      }
    })
    return value
  }
}

let dbUtil: DBUtil = new DBUtil();

export default dbUtil;