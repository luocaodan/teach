export default class TestRecord {
  static valueOf(obj) {
    const res = new TestRecord();
    res.student = obj.student;
    const units = JSON.parse(obj.unittest);
    if (!units) {
      res.unitTestsSummary = '无';
      res.unitTests = null;
    } else {
      res.unitTestsSummary = `${units.passed}/${units.total}`;
      res.unitTests = units.testcases;
    }
    const score = JSON.parse(obj.score);
    if (!score) {
      res.correctsSummary = '无';
      res.corrects = null;
      res.wrongsSummary = '无';
      res.wrongs = null;
      res.cost = '无';
    }
    else {
      res.correctsSummary = `${score.CorrectPassed}/${score.CorrectTotal}`;
      res.corrects = score.CorrectTests;
      res.wrongsSummary = `${score.WrongPassed}/${score.WrongTotal}`;
      res.wrongs = score.WrongTests;
      // seconds
      if (score.CorrectPassed !== score.CorrectTotal) {
        res.cost = '未通过';
      }
      else {
        res.cost = score.TotalTime;
      }
    }
    return res;
  }
}