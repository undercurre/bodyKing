import keepService from '../../service/KeepService'
import DateUtil from '../../utils/DateUtil'
import AchievementInfo from '../../viewmodel/AchievementInfo'
import AchievementMapInfo from '../../viewmodel/AchievementMapInfo'
import KeepInfo from '../../viewmodel/KeepInfo'
import RecordVO from '../../viewmodel/RecordVO'
import AchievementTop from './AchievementTop'

@Component
export default struct AchievementContent {
  achievementMapInfo: AchievementMapInfo = new AchievementMapInfo()

  @StorageProp('date')
  @Watch('aboutToAppear')
  date: number = DateUtil.beginTimeOfDay(new Date())

  @State calorie: number = 0;
  @State consume: number = 0;

  @Link isRefreshing: boolean;

  @State successDays: number = 9
  @State success: Array<AchievementInfo> = [
    new AchievementInfo(3,
      this.achievementMapInfo.on_3,
      this.achievementMapInfo.off_3),

    new AchievementInfo(7,
      this.achievementMapInfo.on_7,
      this.achievementMapInfo.off_7)
  ]

  @State records: RecordVO[] = []

  @State keepInfo: KeepInfo = new KeepInfo()

  @State allRecords: RecordVO[] = []

  async aboutToAppear(): Promise<void> {
    this.records = await keepService.selectRecordByDate(this.date)
    console.log('根据日期查询任务')
    this.keepInfo = keepService.calculateKeepInfo(this.records)
    this.calorie = this.keepInfo.expend
    this.consume = 0
    this.records.forEach(item => {
      this.consume += item.calorie / item.amount * item.successAmount
      if (item.successAmount === item.amount) {
        this.keepInfo.successTask += 1
        console.log('完成数 + 1, 当日完成任务个数：' + this.keepInfo.successTask)
      }
    })
    this.allRecords = await keepService.selectAllRecord()
    console.log('查询所有任务')
    this.successDays = 0
    for (let i  = 0; i < this.allRecords.length; i++) {
      if(i > 0 && this.allRecords[i].createTime === this.allRecords[i-1].createTime) {

      } else {
        let ro: RecordVO[] = await keepService.selectRecordByDate(this.allRecords[i].createTime)
        let info = keepService.calculateKeepInfo(ro)
        if (info.isSuccess === true) {
          this.successDays += 1
        }
      }
    }
    console.log('完成天数：' + this.successDays)
  }

  build() {
    Refresh({refreshing: this.isRefreshing}) {
    Column() {
      Row() {
        AchievementTop({ calorie: $calorie, consume: $consume })
      }
      .height('40%')

      Column() {
        Row() {
          Text('成就')
            .fontSize(20)
            .fontWeight(500)
            .fontColor(Color.White)
        }
        .width('95%')
        Column({ space: 10 }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.success, (item: AchievementInfo) => {
              Column() {
                Image(this.successDays >= item.days ? item.icOn : item.icOff)
                  .width('100%')
                  .height(88)
                  .objectFit(ImageFit.Contain)
                Text($r('app.string.task_achievement_level', item.days))
                  .lineHeight(16)
                  .fontSize(12)
                  .fontColor(Color.White)
              }
              .width('33%')
              .padding({ top: 38, bottom: 10 })
            })
          }
        }
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    }
    .onRefreshing(() => {
      this.aboutToAppear()
      setTimeout(() => {
        this.isRefreshing = false
      }, 500)
    })
  }
}