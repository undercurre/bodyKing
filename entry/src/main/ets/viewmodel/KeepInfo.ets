export default class KeepInfo {
  day: number = 0;
  expend: number = 0;
  task: number = 0;
  successTask: number = 0;
  isSuccess: boolean = false;

  constructor(day: number = 0, expend: number = 0, task: number = 0, successTask: number = 0) {
    this.day = day;
    this.expend = expend;
    this.task = task;
    this.successTask = successTask;
    if (this.successTask === this.task && this.task !== 0) {
      this.isSuccess = true
    }
  }
}