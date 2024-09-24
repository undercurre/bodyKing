import RecordItemModel from '../model/RecordItemModel';
import RecordItem from './RecordItem'

export default class RecordVO {
  id: number;
  keepId: number;
  calorie: number;
  recordItem: RecordItem;
  amount: number = 0;
  successAmount: number = 0;
  createTime: number;

  constructor(id: number, keepId: number, calorie: number, recordItem: RecordItem, amount: number, successAmount: number, createTime: number) {
    this.id = id
    this.keepId = keepId
    this.calorie = calorie
    this.amount = amount
    this.successAmount = successAmount
    this.createTime = createTime
    this.recordItem = RecordItemModel.getById(this.keepId)
  }
}