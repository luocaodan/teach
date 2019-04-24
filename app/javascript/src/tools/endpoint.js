export default class Endpoint {
  static getPrefix(endpoint) {
    const index = endpoint.lastIndexOf('.json');
    return endpoint.substr(0, index)
  }
}