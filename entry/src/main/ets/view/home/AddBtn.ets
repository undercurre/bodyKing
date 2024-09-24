@Component
export default struct AddBtn {
  clickAction: Function = () => {}
  build() {
    Button({ type: ButtonType.Circle, stateEffect: false }) {
      Image($r('app.media.add_icon'))
        .borderRadius('50%')
        .width('100%')
        .height('100%')
    }
    .zIndex(2)
    .position({ x: '78%', y: '48%' })
    .width(48)
    .height(48)
    .backgroundColor(Color.White)
    .onClick(() => this.clickAction())
  }
}