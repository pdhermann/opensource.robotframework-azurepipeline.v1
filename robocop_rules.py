from robocop.checkers import VisitorChecker
from robocop.rules import Rule, RuleSeverity

rules = {
    "9999": Rule(rule_id="9999", name="dummy-in-name", msg="There is 'Dummy' in test case name", severity=RuleSeverity.ERROR)
}


class NoDummiesChecker(VisitorChecker):
    reports = ("dummy-in-name",)

    def visit_TestCaseName(self, node):
        if 'Dummy' in node.name:
            self.report("dummy-in-name", node=node, col=node.name.find('Dummy'))