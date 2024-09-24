import DateDialog from '../../dialog/DateDialog'
import DateUtil from '../../utils/DateUtil'

@Extend(Text)
function textStyle(color: ResourceStr | Color, fw: number | FontWeight) {
  .fontSize(20)
  .fontWeight(fw)
  .fontColor(color)
}

@Preview
@Component
export default struct AchievementTop {
  @Link calorie: number;
  @Link consume: number;
  @StorageProp('date') date: number = DateUtil.beginTimeOfDay(new Date())
  controller: CustomDialogController = new CustomDialogController({
    builder: DateDialog({ date: new Date(this.date) })
  })

  build() {
    Column({ space: 5 }) {
      Column() {
        Text(DateUtil.formatDate(this.date))
          .fontSize(15)
          .fontColor(Color.Gray)
          .onClick(() => {
            this.controller.open()
          })
        Text('健身记录')
          .textStyle(Color.White, 800)
      }
      .width('95%')
      .margin({ top: 30, bottom: 10 })
      .alignItems(HorizontalAlign.Start)
      Row() {
        Column({ space: 5 }) {
          Text('运动消耗')
            .textStyle(Color.White, 500)
          Text(this.consume + '/' + this.calorie + '千卡')
            .textStyle(Color.Green, 800)
            .margin({right: 20, bottom: 30})
          Text('距离目标')
            .textStyle(Color.White, 500)
          Text((this.calorie - this.consume) + '千卡')
            .textStyle($r('app.color.confirm_btn'), 800)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 5 })
        Progress({
          value: this.consume,
          total: this.calorie,
          type: ProgressType.Ring
        })
          .color(Color.Black)
          .backgroundColor(Color.Red)
          .width('50%')
          .height('95%')
          .style({ strokeWidth: 25 })
      }
      .backgroundColor(Color.Gray)
      .width('95%')
      .height(190)
      .borderRadius(15)
    }
    .width('100%')
    .height('100%')
  }
}