enum Mode{
  editTicket,
  openTicket,
  none;

  static Mode fromJson(String json) => values.byName(json);
}
