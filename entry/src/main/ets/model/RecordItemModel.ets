import RecordItem from '../viewmodel/RecordItem'

const keeps: RecordItem[] = [
  new RecordItem(0, '跳绳', $r('app.media.sport'), '/小时', 600),
  new RecordItem(0, '游泳', $r('app.media.sport'), '/小时', 400),
  new RecordItem(0, '卧推', $r('app.media.sport'), '/个', 50),
]

class ItemModel {
  getById(id: number) {
    return keeps[id]
  }

  list(): RecordItem[] {
    return keeps
  }
}

let itemModel = new ItemModel()

export default itemModel