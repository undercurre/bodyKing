
@CustomDialog
export default struct UserPrivacyDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: '' })
  cancel: Function = () => {
  }
  confirm: Function = () => {
  }

  build() {
    Column({ space: 10 }) {
      Text($r('app.string.privacy_title'))
        .fontSize(20)
        .fontWeight(FontWeight.Bolder)
        .margin({ top: 8, bottom: 5 })
      Text() {
        Span($r('app.string.privacy_content_one'))
        Span($r('app.string.privacy_content_two'))
          .fontColor($r('app.color.privacy_color'))
        Span($r('app.string.privacy_content_three'))
        Span($r('app.string.email'))
          .fontColor($r('app.color.privacy_color'))
      }
      .margin({ top: 20 })

      Column({ space: 10 }) {
        Button('同意')
          .fontColor(Color.White)
          .backgroundColor($r("app.color.privacy_color"))
          .width('80%')
          .onClick(() => {
            this.confirm()
            this.controller.close()
          })
        Button('不同意')
          .fontColor(Color.Gray)
          .backgroundColor($r("app.color.privacy_dis_color"))
          .width('80%')
          .onClick(() => {
            this.cancel()
            this.controller.close()
          })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('80%')
    .height('75%')
    .padding(20)
  }
}