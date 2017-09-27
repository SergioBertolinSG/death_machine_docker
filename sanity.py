import sys
sys.path.append("populator")
from populator.populator import Populator

p = Populator("description.json")
p.wait_until_server_is_up()
