import UserPrivacyDialog from '../dialog/UserPrivacyDialog'
import { common } from '@kit.AbilityKit'
import data_preferences from '@ohos.data.preferences'
import { router } from '@kit.ArkUI'

// 定义常量存储首选项中的键
const H_STORE: string = 'healthAppStore'
const IS_PRIVACY: string = 'isPrivacy'

@Entry
@Component
struct SplashIndex {
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  dialogController: CustomDialogController = new CustomDialogController({
    builder: UserPrivacyDialog({
      cancel: () => {
        this.exitApp()
      },
      confirm: () => {
        this.onConfirm()
      }
    })
  })

  onConfirm() {
    let preferences = data_preferences.getPreferences(this.context, H_STORE);
    preferences.then((res) => {
      res.put(IS_PRIVACY, true).then(() => {
        res.flush()
        this.jumpToMain()
      }).catch((err: Error) => {
        console.log('isPrivacy记录失败，原因：' + err);
      })
    })
  }

  exitApp() {
    this.context.terminateSelf()
  }

  aboutToAppear(): void {
    let preferences = data_preferences.getPreferences(this.context, H_STORE)
    preferences.then((res) => {
      res.get(IS_PRIVACY, false).then((isPrivacy) => {
        if (isPrivacy === true) {
          this.jumpToMain()
        } else {
          this.dialogController.open()
        }
      })
    })
  }

  jumpToMain() {
    setTimeout(() => {
      router.replaceUrl({url: 'pages/Main'})
    }, 2000)
  }

  aboutToDisappear(): void {
    clearTimeout()
  }

  build() {
    Column() {
      Image($r('app.media.logo'))
        .width(100)
        .margin({top: 120})
        .borderRadius(8)
      Text('Welcome to BodyKing !')
        .fontSize(15)
        .fontColor('#fff')
        .fontWeight(700)
        .letterSpacing(0.1)
        .opacity(0.9)
        .margin({top: 20})
      Image($r('app.media.BodyKing'))
        .width('80%')
        .margin({top: 40})
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize({width: '100%', height: '100%'})
    .backgroundImagePosition({x: 0, y: 0})
  }
}

// 记得在resources/base/profile/main_pages里添加页面菜生效