import RecordPO from '../common/RecordPO'
import dbUtil from '../utils/DBUtil'
import { ColumnInfo, ColumnType } from '../viewmodel/ColumnInfo'
import { relationalStore } from '@kit.ArkData'

const CREATE_TABLE_SQL: string = `
CREATE TABLE IF NOT EXISTS record
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  keep_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  create_time INTEGER NOT NULL,
  success_amount INTEGER NOT NULL,
)`

const COLUMNS: ColumnInfo[] = [
  {name: 'id', columnName: 'id', type: ColumnType.LONG},
  {name: 'keepId', columnName: 'keep_id', type: ColumnType.LONG},
  {name: 'amount', columnName: 'amount', type: ColumnType.DOUBLE},
  {name: 'createTime', columnName: 'create_time', type: ColumnType.LONG},
  {name: 'successAmount', columnName: 'success_amount', type: ColumnType.DOUBLE},
]

const TABLE_NAME = 'record'
const ID_COLUMN = 'id'
const DATE_COLUMN = 'create_time'

class RecordModel {
  getCreateTableSql(): string {
    return CREATE_TABLE_SQL
  }

  insert(record: RecordPO) {
    return dbUtil.insert(TABLE_NAME, record, COLUMNS)
  }

  delete(id: number) {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(ID_COLUMN, id)
    return dbUtil.delete(predicates)
  }

  update(record: RecordPO, id: number) {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(ID_COLUMN, id)
    return dbUtil.update(record, COLUMNS, predicates)
  }

  queryAll(): Promise<RecordPO[]> {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    return dbUtil.queryForList(predicates, COLUMNS)
  }

  queryByDate(date: number): Promise<RecordPO[]> {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(DATE_COLUMN, date)
    return dbUtil.queryForList(predicates, COLUMNS)
  }
}

let recordModel = new RecordModel()

export default recordModel