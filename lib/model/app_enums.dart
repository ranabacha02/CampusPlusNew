enum Faculty {
  msfea("Maroun Semaan Faculty of Engineering and Architecture"),
  fas("Faculty of Arts and Sciences"),
  fhs("Faculty of Health Sciences"),
  fafs("Faculty of Agricultural and Food Sciences"),
  fm("Faculty of Medicine"),
  osb("Suliman S. Olayan School of Business"),
  hson("Hariri School of Nursing");

  const Faculty(this.departmentName);

  final String departmentName;
}

enum Gender {
  female("Female"),
  male("Male"),
  other("Other");

  const Gender(this.gender);

  final String gender;
}
