import AchievementContent from '../view/achievement/AchievementContent'
import HomeContent from '../view/home/HomeContent'
import MineContent from '../view/mine/MineContent'

@Entry
@Component
struct MainIndex {
  @State selectIndex: number = 0

  @State isRefreshing: boolean = true

  @Builder TabBarBuilder(index: number, normalIcon: ResourceStr, selIcon: ResourceStr, text: string) {
    Column() {
      Image(this.selectIndex === index ? selIcon : normalIcon)
        .width(20)
      Text(text)
        .fontSize(10)
        .fontColor(this.selectIndex === index ? $r('app.color.tab_bar_sel') : $r('app.color.tab_bar_normal'))
    }
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      index: this.selectIndex
    }) {
      TabContent() {
        HomeContent()
      }
        .tabBar(this.TabBarBuilder(0, $r('app.media.tab_home_normal'), $r('app.media.tab_home_sel'), '主页'))
      TabContent() {
        AchievementContent({ isRefreshing: this.isRefreshing })
      }
        .tabBar(this.TabBarBuilder(1, $r('app.media.tab_medal_normal'), $r('app.media.tab_medal_sel'), '成就'))
      TabContent() {
        MineContent()
      }
        .tabBar(this.TabBarBuilder(2, $r('app.media.tab_user_normal'), $r('app.media.tab_user_sel'), '个人'))
    }
    .onChange((index: number) => {
      this.selectIndex = index;
      if (index === 1) {
        this.isRefreshing = true
      }
    })
  }
}