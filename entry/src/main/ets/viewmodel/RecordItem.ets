export default class RecordItem {
  id: number;
  name: ResourceStr;
  image: ResourceStr;
  unit: ResourceStr;
  calorie: number;

  constructor(id: number, name: ResourceStr, image: ResourceStr, unit: ResourceStr, calorie: number) {
    this.id = id
    this.name = name
    this.image = image
    this.unit = unit
    this.calorie = calorie
  }
}