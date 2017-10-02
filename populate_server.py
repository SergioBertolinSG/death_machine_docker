import sys
sys.path.append("populator")
from populator.populator import Populator

p = Populator("description.json")
p.check_connection()

p.create_users()
p.create_groups()
p.create_folders()
p.upload_files()
p.create_shares()
