
@CustomDialog
export default struct DateDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: '' })
  date: Date = new Date()

  build() {
    Column() {
      DatePicker({
        start: new Date('2020-01-01'),
        end: new Date(),
        selected: this.date
      })
        .padding(20)
        .onDateChange((value: Date) => {
          this.date.setFullYear(value.getFullYear(), value.getMonth(), value.getDate())
        })
      Row({ space: 10 }) {
        Button('Cancel')
          .width(120)
          .backgroundColor($r('app.color.cancel_btn'))
          .onClick(() => {
            this.controller.close()
          })
        Button('Confirm')
          .width(120)
          .backgroundColor($r('app.color.confirm_btn'))
          .onClick(() => {
            AppStorage.setOrCreate('date', this.date.getTime())
            this.controller.close()
          })
      }
    }
    .padding(12)
  }
}