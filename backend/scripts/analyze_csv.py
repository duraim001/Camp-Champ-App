import csv
import re

csv_path = 'database/IVth year students details.csv'

with open(csv_path, encoding='utf-8') as f:
    rows = list(csv.DictReader(f))

print(f"Total Rows in CSV: {len(rows)}")
print("=" * 80)

seen_regs = {}
seen_emails = {}
duplicates = []

for idx, r in enumerate(rows, 1):
    name = r.get('NAME', '').strip()
    reg = r.get('Register number', '').strip()
    email = r.get('Email', '').strip().lower()
    phone = r.get('Phone Number', '').strip()
    course = r.get('Course', '').strip()
    year = r.get('Year', '').strip()
    dept = r.get('Department', '').strip()
    sem = r.get('Semester', '').strip()
    
    dup_flag = ""
    if reg in seen_regs:
        prev_idx, prev_name = seen_regs[reg]
        dup_flag += f" [DUP REG: same as row {prev_idx} ({prev_name})]"
        duplicates.append((idx, name, reg, 'duplicate_reg', prev_idx, prev_name))
    else:
        seen_regs[reg] = (idx, name)
        
    if email in seen_emails:
        prev_idx, prev_name = seen_emails[email]
        dup_flag += f" [DUP EMAIL: same as row {prev_idx} ({prev_name})]"
        duplicates.append((idx, name, email, 'duplicate_email', prev_idx, prev_name))
    else:
        seen_emails[email] = (idx, name)
        
    # Username and password generation test
    # Student Name + Last 2 Digits of Register Number
    # Example: Duraimurugan + 13 -> duraimurugan13
    clean_name = re.sub(r'[^a-zA-Z0-9]', '', name.split()[0]).lower() if name else "student"
    last2 = reg[-2:] if len(reg) >= 2 else "00"
    gen_username = clean_name
    gen_password = f"{clean_name}{last2}"
    
    print(f"{idx:2d}: {name:28s} | Reg: {reg:12s} | Last2: {last2:2s} | Pass: {gen_password:20s} | Email: {email:32s}{dup_flag}")

print("=" * 80)
print(f"Total Duplicate issues found: {len(duplicates)}")
for d in duplicates:
    print(f" - Row {d[0]} ({d[1]}) has {d[3]}: '{d[2]}' with Row {d[4]} ({d[5]})")
