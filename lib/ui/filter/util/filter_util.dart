enum FilterComponentEnum {
  NONE,
  SLIDER,
  RANGE_SLIDER,
  SELECTION,
  MULTI_SELECTION,
  DATE,
  ICON_SINGLE_SELECTION,
  ICON_MULTI_SELECTION
}
const FILTER_KEY_VALUE_RIGHT = 'valueRight';
const FILTER_KEY_VALUE_LEFT = 'valueLeft';
const FILTER_KEY_ID = 'fid';
const FILTER_KEY_TYPE = 'type';
const FILTER_KEY_VALUE = 'value';
const FILTER_KEY_START_DATE = 'startDate';
const FILTER_KEY_END_DATE = 'endDate';
const FILTER_KEY_KEY = 'key';
const FILTER_KEY_MAX = 'Max';
const FILTER_KEY_MIN = 'Min';

///Return Type Filter Component by Filter Component Enum
dynamic getTypeByEnum(String value) {
  switch (value) {
    case 'slider':
      return FilterComponentEnum.SLIDER;
    case 'range_slider':
      return FilterComponentEnum.RANGE_SLIDER;
    case 'selection':
      return FilterComponentEnum.SELECTION;
    case 'multi_selection':
      return FilterComponentEnum.MULTI_SELECTION;
    case 'icon_single_selection':
      return FilterComponentEnum.ICON_SINGLE_SELECTION;
    case 'icon_multi_selection':
      return FilterComponentEnum.ICON_MULTI_SELECTION;
    case 'date':
      return FilterComponentEnum.DATE;
    default:
      return FilterComponentEnum.NONE;
  }
}

String describeEnum(Object enumEntry) {
  final description = enumEntry.toString();
  final indexOfDot = description.indexOf('.');
  assert(
    indexOfDot != -1 && indexOfDot < description.length - 1,
    'The provided object "$enumEntry" is not an enum.',
  );
  return description.substring(indexOfDot + 1).toLowerCase();
}
