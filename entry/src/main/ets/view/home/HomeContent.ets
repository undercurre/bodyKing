import DateDialog from '../../dialog/DateDialog'
import DateUtil from '../../utils/DateUtil'
import AddBtn from './AddBtn';
import { router } from '@kit.ArkUI';
import { sportMission } from '../../pages/AddTaskPage';
import RecordVO from '../../viewmodel/RecordVO';
import RecordPO from '../../common/RecordPO';
import KeepInfo from '../../viewmodel/KeepInfo';
import keepService from '../../service/KeepService';

@Component
export default struct HomeContent {
  @StorageProp('date') date: number = DateUtil.beginTimeOfDay(new Date())

  @State
  @Watch('onRecordsChange')
  records: RecordVO[] = []

  @State
  recordPOs: RecordPO[] = []

  @State keepInfo: KeepInfo = new KeepInfo();

  @State arr: sportMission[] = []

  async aboutToAppear() {
    this.records = await keepService.selectRecordByDate(this.date)
    console.log('根据日期查')
  }

  onRecordsChange() {
    this.keepInfo = keepService.calculateKeepInfo(this.records)
  }

  clickDelBtn(id: number) {
    keepService.deleteById(id)
    this.aboutToAppear()
  }

  @Builder DelBtn(id: number) {
    Button() {
      Image($r('app.media.delete'))
        .width(20)
        .fillColor(Color.Red)
    }
    .width(30)
    .height(30)
    .backgroundColor(Color.White)
    .stateEffect(false)
    .onClick(() => {
      this.clickDelBtn(id)
    })
  }

  addTask() {
    router.pushUrl({url: 'pages/AddTaskPage'})
  }

  controller: CustomDialogController = new CustomDialogController({
    builder: DateDialog({
      date: new Date(this.date)
    })
  })

  build() {
    Column() {
      Column() {
        Text('BodyKing')
          .fontSize(25)
          .fontWeight(600)
          .fontColor('#fff')
          .margin({ top: 10, bottom: 100, left: 20 })

        Row() {
          Text(DateUtil.formatDate(this.date))
            .fontSize(15)
            .fontWeight(500)
          Image($r('app.media.arrow_down'))
            .width(20)
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .margin({ left: 19, top: 90 })
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.controller.open()
        })
      }
      .backgroundImage($r('app.media.home_bg'))
      .backgroundImageSize({ width: '100%', height: 330 })
      .width('100%')
      .height('40%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius({ bottomLeft: 20, bottomRight: 20 })

      Stack() {
        Column() {
          Text('Missions')
            .fontSize(13)
            .fontWeight(700)
            .margin({ top: 20, bottom: 10 })
          if (this.records.length !== 0) {
            Column() {
              List({ space: 10 }) {
                ForEach(this.records, (item: RecordVO) => {
                  ListItem() {
                    Row() {
                      Row() {
                        Image(item.recordItem.image)
                          .width(40)
                          .height(40)
                          .padding(5)
                        Text(item.recordItem.name)
                          .fontSize(13)
                          .fontWeight(600)
                          .opacity(0.8)
                      }
                      .onClick(() => {
                        if (item.successAmount <= item.amount - item.amount % 1 - 1) {
                          item.successAmount += 1;
                          keepService.update(item)
                          this.aboutToAppear()
                          console.log('完成个数+1')
                        } else if (item.successAmount > item.amount - item.amount % 1 - 1) {
                          item.successAmount = item.amount;
                          keepService.update(item)
                          this.aboutToAppear()
                          console.log('该任务已完成')
                        }
                      })
                      Blank()
                      if (item.amount === item.successAmount) {
                        Text('消耗' + item.calorie + '卡路里')
                          .fontSize(13)
                          .fontWeight(600)
                          .margin({ right: 10 })
                          .fontColor('#000')
                      } else {
                        Text(item.successAmount + ':' + item.amount  + item.recordItem.unit)
                          .fontSize(13)
                          .fontWeight(600)
                          .margin({ right: 10 })
                      }
                    }
                    .width('100%')
                    .backgroundColor(Color.White)
                    .shadow({
                      radius: 10,
                    })
                    .border({
                      width: 2
                    })
                    .borderRadius(15)
                  }
                  .swipeAction({
                    end: this.DelBtn(item.id)
                  })
                })
              }
            }
            .padding(10)
          } else {
            Column() {
              Text('空空如也')
                .fontSize(28)
                .opacity(0.4)
            }
            .margin({ top: 68 })
          }
        }
        .alignItems(HorizontalAlign.Center)

        AddBtn({
          clickAction: () => {
            this.addTask()
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}