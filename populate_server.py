import sys
sys.path.append("populator")
from populator.populator import Populator

p = Populator("description.json")
p.check_connection()
