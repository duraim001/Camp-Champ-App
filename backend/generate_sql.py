import csv
import os
import re

csv_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'IVth year students details.csv')
sql_out = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'import_4th_year_students.sql')

with open(csv_path, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    rows = list(reader)

lines = []
lines.append('-- ====================================================================')
lines.append('-- 4th-Year AI&DS Students SQL Import Script for Supabase / PostgreSQL')
lines.append(f'-- Total Students: {len(rows)}')
lines.append('-- Architecture: Camp Champ College Management System')
lines.append('-- ====================================================================')
lines.append('')
lines.append('CREATE EXTENSION IF NOT EXISTS pgcrypto;')
lines.append('')
lines.append('-- 1. Ensure Artificial Intelligence & Data Science Department Exists')
lines.append("""INSERT INTO departments (id, name, code, is_active, created_at, updated_at)
VALUES (1, 'Artificial Intelligence and Data Science', 'AI&DS', true, NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    code = EXCLUDED.code, 
    updated_at = NOW();
""")

lines.append('-- 2. Insert/Update Users and Students in a Transaction Block')
lines.append('DO $$')
lines.append('DECLARE')
lines.append('    dept_id_val INT := 1;')
lines.append('    new_user_id INT;')
lines.append('BEGIN')

seen_usernames = {}
seen_regs = {}

for idx, r in enumerate(rows, 1):
    raw_name = r['NAME'].strip()
    clean_name = re.sub(r'[^a-zA-Z0-9]', '', raw_name).lower()
    if not clean_name:
        clean_name = f'student{idx:02d}'
    
    first_part = clean_name.split()[0] if ' ' in clean_name else clean_name
    base_user = first_part
    if base_user in seen_usernames:
        seen_usernames[base_user] += 1
        username = f'{base_user}{seen_usernames[base_user]:02d}'
    else:
        seen_usernames[base_user] = 1
        username = base_user
        
    reg_no = r['Register number'].strip()
    if reg_no in seen_regs:
        reg_no = f'{reg_no}-{idx}'
    else:
        seen_regs[reg_no] = True

    email = r['Email'].strip().lower()
    phone = r['Phone Number'].strip()
    course = r['Course'].strip() or 'B.TECH'
    year_str = r['Year'].strip() or 'IV'
    dept_name = r['Department'].strip() or 'Artificial intelligence and Data science'
    sem = r['Semester'].strip() or 'VII'
    
    last2 = reg_no[-2:] if len(reg_no) >= 2 else '01'
    plain_pw = f'{clean_name}{last2}'
    
    escaped_name = raw_name.replace("'", "''")
    escaped_email = email.replace("'", "''")
    
    lines.append(f'    -- Student #{idx}: {raw_name} ({reg_no}) | Username: {username} | Password: {plain_pw}')
    lines.append(f"""    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('{username}', '{escaped_email}', crypt('{plain_pw}', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
    ON CONFLICT (username) DO UPDATE SET 
        email = EXCLUDED.email, 
        password_hash = EXCLUDED.password_hash,
        department_id = EXCLUDED.department_id,
        updated_at = NOW()
    RETURNING id INTO new_user_id;

    INSERT INTO students (
        user_id, name, register_number, roll_number, department, department_id,
        course, year, year_of_study, semester, email, phone, status, created_at, updated_at
    )
    VALUES (
        new_user_id, '{escaped_name}', '{reg_no}', '{idx:02d}', '{dept_name}', dept_id_val,
        '{course}', '{year_str}', 4, '{sem}', '{escaped_email}', '{phone}', 'Active', NOW(), NOW()
    )
    ON CONFLICT (register_number) DO UPDATE SET
        user_id = EXCLUDED.user_id,
        name = EXCLUDED.name,
        department = EXCLUDED.department,
        department_id = EXCLUDED.department_id,
        course = EXCLUDED.course,
        year = EXCLUDED.year,
        year_of_study = EXCLUDED.year_of_study,
        semester = EXCLUDED.semester,
        email = EXCLUDED.email,
        phone = EXCLUDED.phone,
        status = EXCLUDED.status,
        updated_at = NOW();
""")

lines.append('END $$;')

with open(sql_out, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Successfully generated {sql_out} with {len(rows)} students!')
