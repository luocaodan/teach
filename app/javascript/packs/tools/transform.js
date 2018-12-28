export default class {
  static toCamelCase(name) {
    let camel = name.replace(/\_(\w)/g, (match, group) => {
      return group.toUpperCase();
    });
    return camel;
  }

  static toUnderLine(name) {
    return name.replace(/([A-Z])/g, '_$1').toLowerCase();
  }
}