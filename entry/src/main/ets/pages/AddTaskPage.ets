import { router } from '@kit.ArkUI'
import TaskAddDialog from '../dialog/TaskAddDialog';
import RecordItemModel from '../model/RecordItemModel';
import RecordItem from '../viewmodel/RecordItem';

export interface sportMission {
  name: string;
  icon: Resource;
  consume: number;
  num: number;
  target: number;
  pre: string;
}

@Preview
@Entry
@Component
export default struct AddTaskPage {

  @State itemId: number = 0;

  controller: CustomDialogController = new CustomDialogController({
    builder: TaskAddDialog({ itemId: this.itemId })
  })

  @State arr: RecordItem[] = RecordItemModel.list()

  clickAddBtn(id: number) {
    this.itemId = id
    this.controller.open()
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(25)
      }
      .width('100%')
      .margin({ top: 10, left: 10 })
      .justifyContent(FlexAlign.Start)
      .padding({ left: 10, right: 10, bottom: 10 })
      .onClick(() => {
        router.back()
      })

      List({ space: 10 }) {
        ForEach(this.arr, (item: RecordItem) => {
          ListItem() {
            Row() {
              Image(item.image)
                .width(40)
                .height(40)
                .margin({ right: 15 })
              Column() {
                Text(item.name)
                  .fontSize(15)
                  .fontWeight(500)
                Text(item.calorie + '卡路里' + item.unit)
                  .fontSize(10)
                  .fontWeight(600)
                  .opacity(0.7)
              }
              .alignItems(HorizontalAlign.Start)
              Blank()
              Button() {
                Image($r('app.media.add_task_icon'))
                  .width(20)
                  .backgroundColor(Color.White)
                  .onClick(() => this.clickAddBtn(this.itemId))
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .backgroundColor(Color.White)
          .border({
            width: {
              top: 2,
              bottom: 2
            }
          })
          .shadow({
            radius: 10
          })
          .padding(5)
        })
      }
      .width('100%')
      .alignListItem(ListItemAlign.Center)
    }
  }
}