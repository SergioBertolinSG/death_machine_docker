import sys
sys.path.append("populator")
from populator.populator import Populator

p = Populator("description.json")

p.check_users()
p.check_groups()
p.check_shares()
p.check_files()
