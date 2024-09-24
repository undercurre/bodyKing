import preferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';

class PreferenceUtil {
  private pref: preferences.Preferences | null = null;

  async loadPreference(context: common.UIAbilityContext) {
    try {
      this.pref = await preferences.getPreferences(context, 'BodyKingStore')
      console.log('加载Preference【BodyKingStore】成功')
    } catch (e) {
      console.log('加载Preference【BodyKingStore】失败', JSON.stringify(e))
    }
  }

  async setPreferenceValue(key: string, value: preferences.ValueType) {
    if (!this.pref) {
      console.log('Preference【BodyKingStore】未初始化')
      return
    }
    try {
      await this.pref.put(key, value);
      await this.pref.flush();
      console.log(`保存Preference[${key} = ${value}]成功`)
    } catch (e) {
      console.log(`保存Preference[${key} = ${value}]失败`, JSON.stringify(e))
    }
  }

  async getPreferenceValue(key: string, defaultValue: preferences.ValueType) {
    if (!this.pref) {
      console.log('Preference【BodyKingStore】未初始化')
      return null
    }
    try {
      let value = await this.pref.get(key, defaultValue);
      console.log(`保存Preference[${key} = ${value}]成功`);
      return value;
    } catch (e) {
      console.log(`保存Preference[${key}}]失败`, JSON.stringify(e))
    }
    return null
  }
}

const preferencesUtil: PreferenceUtil = new PreferenceUtil()

export default preferencesUtil