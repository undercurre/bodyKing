import RecordPO from '../common/RecordPO';
import RecordItemModel from '../model/RecordItemModel';
import RecordModel from '../model/RecordModel'
import DateUtil from '../utils/DateUtil'
import KeepInfo from '../viewmodel/KeepInfo';
import RecordVO from '../viewmodel/RecordVO';

class  KeepService {
  insert(keepId: number, amount: number): Promise<number> {
    let createTime = (AppStorage.Get('selectedDate') || DateUtil.beginTimeOfDay(new Date())) as number;

    return RecordModel.insert({keepId: keepId, amount: amount, createTime: createTime, successAmount: 0})
  }

  deleteById(id: number): Promise<number> {
    return RecordModel.delete(id)
  }

  update(record: RecordVO): Promise<number> {
    return RecordModel.update({ id: record.id, keepId: record.keepId, amount: record.amount, successAmount: record.successAmount, createTime: record.createTime }, record.id!)
  }

  async selectAllRecord(): Promise<RecordVO[]> {
    let rps = await RecordModel.queryAll()

    return rps.map(rp => {
      let rv: RecordVO = new RecordVO(
        rp.id!,
        rp.keepId!,
        rp.amount * RecordItemModel.getById(rp.keepId!).calorie,
        RecordItemModel.getById(rp.keepId!),
        rp.amount,
        rp.successAmount,
        rp.createTime!
      )
      return rv
    })
  }

  async selectRecordByDate(date: number): Promise<RecordVO[]> {
    let rps = await RecordModel.queryByDate(date)

    return rps.map(rp => {
      let rv: RecordVO = new RecordVO(
        rp.id!,
        rp.keepId!,
        rp.amount * RecordItemModel.getById(rp.keepId!).calorie,
        RecordItemModel.getById(rp.keepId!),
        rp.amount,
        rp.successAmount,
        rp.createTime!
      )
      return rv
    })
  }

  calculateKeepInfo(records: RecordVO[]): KeepInfo {
    let info = new KeepInfo()
    if (!records || records.length <= 0) {
      return info
    }
    info.task = records.length
    records.forEach(rv => {
      if (rv.amount !== 0 && rv.successAmount === rv.amount) {
        info.successTask += 1
      }
      info.expend += rv.calorie
      info.day = rv.createTime
    })

    if (info.task === info.successTask && info.task !== 0) {
      info.isSuccess = true
    }
    console.log(info.task + '/' + info.successTask + ',任务时间' + info.day + ',总任务/已完成任务')
    return info;
  }
}

let keepService = new KeepService();

export default keepService;