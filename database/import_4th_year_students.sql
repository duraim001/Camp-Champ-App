-- ====================================================================
-- 4th-Year AI&DS Students SQL Import Script for Supabase / PostgreSQL
-- Total Students: 55
-- Architecture: Camp Champ College Management System
-- ====================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Ensure Artificial Intelligence & Data Science Department Exists
INSERT INTO departments (id, name, code, is_active, created_at, updated_at)
VALUES (1, 'Artificial Intelligence and Data Science', 'AI&DS', true, NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    code = EXCLUDED.code, 
    updated_at = NOW();

-- 2. Insert/Update Users and Students in a Transaction Block
DO $$
DECLARE
    dept_id_val INT := 1;
    new_user_id INT;
BEGIN
    -- Student #1: Ajaysagar P (61232319001) | Username: ajaysagarp | Password: ajaysagarp01
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('ajaysagarp', 'kalpanaajaysagar2004@gmail.com', crypt('ajaysagarp01', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Ajaysagar P', '61232319001', '01', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kalpanaajaysagar2004@gmail.com', '6385776502', 'Active', NOW(), NOW()
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

    -- Student #2: Anamika SS (61232319002) | Username: anamikass | Password: anamikass02
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('anamikass', 'anamikass765@gmail.com', crypt('anamikass02', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Anamika SS', '61232319002', '02', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'anamikass765@gmail.com', '6379536060', 'Active', NOW(), NOW()
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

    -- Student #3: Ankit kumar (61232319003) | Username: ankitkumar | Password: ankitkumar03
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('ankitkumar', 'ankitchoudhary08757@gmail.com', crypt('ankitkumar03', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Ankit kumar', '61232319003', '03', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'ankitchoudhary08757@gmail.com', '8102909059', 'Active', NOW(), NOW()
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

    -- Student #4: Arsath Mohamed M (61232319004) | Username: arsathmohamedm | Password: arsathmohamedm04
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('arsathmohamedm', 'mohamedarsath949@gmail.com', crypt('arsathmohamedm04', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Arsath Mohamed M', '61232319004', '04', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'mohamedarsath949@gmail.com', '9043117819', 'Active', NOW(), NOW()
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

    -- Student #5: Athul krishna S (61232319005) | Username: athulkrishnas | Password: athulkrishnas05
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('athulkrishnas', 'athulkrishnasinimol@gmail.com', crypt('athulkrishnas05', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Athul krishna S', '61232319005', '05', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'athulkrishnasinimol@gmail.com', '6374358395', 'Active', NOW(), NOW()
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

    -- Student #6: Balaji V (61232319006) | Username: balajiv | Password: balajiv06
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('balajiv', 'shalinibalaji2004@gmail.com', crypt('balajiv06', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Balaji V', '61232319006', '06', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'shalinibalaji2004@gmail.com', '8248004294', 'Active', NOW(), NOW()
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

    -- Student #7: Bhuvaneshwaran V (61232319007) | Username: bhuvaneshwaranv | Password: bhuvaneshwaranv07
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('bhuvaneshwaranv', 'bhuvaneshvaran03122005@gmail.com', crypt('bhuvaneshwaranv07', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Bhuvaneshwaran V', '61232319007', '07', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'bhuvaneshvaran03122005@gmail.com', '6374322876', 'Active', NOW(), NOW()
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

    -- Student #8: Bhuvaneshwaran R (61232319008) | Username: bhuvaneshwaranr | Password: bhuvaneshwaranr08
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('bhuvaneshwaranr', 'bhuvaneswaran4533@gmail.com', crypt('bhuvaneshwaranr08', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Bhuvaneshwaran R', '61232319008', '08', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'bhuvaneswaran4533@gmail.com', '8220211733', 'Active', NOW(), NOW()
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

    -- Student #9: Chandrika K (61232319009) | Username: chandrikak | Password: chandrikak09
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('chandrikak', 'chandrikakannan2709@gmail.com', crypt('chandrikak09', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Chandrika K', '61232319009', '09', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'chandrikakannan2709@gmail.com', '9994058729', 'Active', NOW(), NOW()
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

    -- Student #10: Dhakchitha C (61232319010) | Username: dhakchithac | Password: dhakchithac10
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('dhakchithac', 'dhakchithac@gmail.com', crypt('dhakchithac10', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Dhakchitha C', '61232319010', '10', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'dhakchithac@gmail.com', '9361382709', 'Active', NOW(), NOW()
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

    -- Student #11: Dharshan M (61232319011) | Username: dharshanm | Password: dharshanm11
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('dharshanm', 'dharshadharsha2823@gmail.com', crypt('dharshanm11', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Dharshan M', '61232319011', '11', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'dharshadharsha2823@gmail.com', '8825508274', 'Active', NOW(), NOW()
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

    -- Student #12: Dhinesh G (61232319012) | Username: dhineshg | Password: dhineshg12
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('dhineshg', 'dhineshdhinesh29612@gmail.com', crypt('dhineshg12', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Dhinesh G', '61232319012', '12', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'dhineshdhinesh29612@gmail.com', '9629432048', 'Active', NOW(), NOW()
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

    -- Student #13: Duraimurugan M (61232319013) | Username: duraimuruganm | Password: duraimuruganm13
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('duraimuruganm', 'duraim636@gmail.com', crypt('duraimuruganm13', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Duraimurugan M', '61232319013', '13', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'duraim636@gmail.com', '8072384905', 'Active', NOW(), NOW()
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

    -- Student #14: Gokul M (61232319014) | Username: gokulm | Password: gokulm14
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('gokulm', 'gokulmurugan91@gmail.com', crypt('gokulm14', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Gokul M', '61232319014', '14', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'gokulmurugan91@gmail.com', '8778908110', 'Active', NOW(), NOW()
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

    -- Student #15: Gokul R (61232319015) | Username: gokulr | Password: gokulr15
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('gokulr', 'gokulabilesh321@gmail.com', crypt('gokulr15', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Gokul R', '61232319015', '15', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'gokulabilesh321@gmail.com', '6374011337', 'Active', NOW(), NOW()
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

    -- Student #16: Harishragavendra A (61232319017) | Username: harishragavendraa | Password: harishragavendraa17
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('harishragavendraa', 'harishragavendra151@gmail.com', crypt('harishragavendraa17', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Harishragavendra A', '61232319017', '16', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'harishragavendra151@gmail.com', '8220197995', 'Active', NOW(), NOW()
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

    -- Student #17: Harshar AT (61232319018) | Username: harsharat | Password: harsharat18
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('harsharat', 'harsharamutha@gmail.com', crypt('harsharat18', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Harshar AT', '61232319018', '17', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'harsharamutha@gmail.com', '9025084494', 'Active', NOW(), NOW()
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

    -- Student #18: Indhuprakash M (61232319020) | Username: indhuprakashm | Password: indhuprakashm20
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('indhuprakashm', 'indhuprakash2022@gmail.com', crypt('indhuprakashm20', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Indhuprakash M', '61232319020', '18', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'indhuprakash2022@gmail.com', '9363654701', 'Active', NOW(), NOW()
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

    -- Student #19: Janani A (61232319021) | Username: janania | Password: janania21
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('janania', 'jananiarumugam88@gmail.com', crypt('janania21', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Janani A', '61232319021', '19', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'jananiarumugam88@gmail.com', '8667847220', 'Active', NOW(), NOW()
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

    -- Student #20: Janasri S (61232319022) | Username: janasris | Password: janasris22
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('janasris', 'spjana55@gmail.com', crypt('janasris22', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Janasri S', '61232319022', '20', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'spjana55@gmail.com', '6382246939', 'Active', NOW(), NOW()
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

    -- Student #21: Jebakumar R (61232319023) | Username: jebakumarr | Password: jebakumarr23
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('jebakumarr', 'jebakumarr2006@gmail.com', crypt('jebakumarr23', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Jebakumar R', '61232319023', '21', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'jebakumarr2006@gmail.com', '6369974500', 'Active', NOW(), NOW()
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

    -- Student #22: Rithika K (61232319044) | Username: rithikak | Password: rithikak44
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('rithikak', 'kumarvrithika@gmail.com', crypt('rithikak44', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Rithika K', '61232319044', '22', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kumarvrithika@gmail.com', '7695921994', 'Active', NOW(), NOW()
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

    -- Student #23: Kabilan K M (61232319024) | Username: kabilankm | Password: kabilankm24
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('kabilankm', 'kabilanmohanraj13@gmail.com', crypt('kabilankm24', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Kabilan K M', '61232319024', '23', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kabilanmohanraj13@gmail.com', '6382194854', 'Active', NOW(), NOW()
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

    -- Student #24: Kavai harasu S (61232319025) | Username: kavaiharasus | Password: kavaiharasus25
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('kavaiharasus', 'kavihaiarasusampath@gmail.com', crypt('kavaiharasus25', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Kavai harasu S', '61232319025', '24', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kavihaiarasusampath@gmail.com', '6382772268', 'Active', NOW(), NOW()
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

    -- Student #25: Kaviya shree S (61232319026) | Username: kaviyashrees | Password: kaviyashrees26
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('kaviyashrees', 'kaviyaselvarasan@gmail.com', crypt('kaviyashrees26', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Kaviya shree S', '61232319026', '25', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kaviyaselvarasan@gmail.com', '7603933706', 'Active', NOW(), NOW()
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

    -- Student #26: Kiruthika D (61232319027) | Username: kiruthikad | Password: kiruthikad27
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('kiruthikad', 'kiruthikaboobesh@gmail.com', crypt('kiruthikad27', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Kiruthika D', '61232319027', '26', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'kiruthikaboobesh@gmail.com', '8722773382', 'Active', NOW(), NOW()
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

    -- Student #27: Thulasidass M (61232319056) | Username: thulasidassm | Password: thulasidassm56
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('thulasidassm', 'thulasid4300@gmail.com', crypt('thulasidassm56', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Thulasidass M', '61232319056', '27', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'thulasid4300@gmail.com', '8610125572', 'Active', NOW(), NOW()
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

    -- Student #28: Maheshwaran C (61232319028) | Username: maheshwaranc | Password: maheshwaranc28
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('maheshwaranc', 'sivamahesh242@gmail.com', crypt('maheshwaranc28', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Maheshwaran C', '61232319028', '28', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sivamahesh242@gmail.com', '8122826171', 'Active', NOW(), NOW()
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

    -- Student #29: Mariammal alis Madhu M (61232319029) | Username: mariammalalismadhum | Password: mariammalalismadhum29
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('mariammalalismadhum', 'mariammalm980@gmail.com', crypt('mariammalalismadhum29', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Mariammal alis Madhu M', '61232319029', '29', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'mariammalm980@gmail.com', '6383946599', 'Active', NOW(), NOW()
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

    -- Student #30: Meganathan R (61232319030) | Username: meganathanr | Password: meganathanr30
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('meganathanr', 'ramasamy.megan@gmail.com', crypt('meganathanr30', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Meganathan R', '61232319030', '30', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'ramasamy.megan@gmail.com', '6369138779', 'Active', NOW(), NOW()
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

    -- Student #31: Nandhakumar S (61232319031) | Username: nandhakumars | Password: nandhakumars31
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('nandhakumars', 'snandhakumar304@gmail.com', crypt('nandhakumars31', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Nandhakumar S', '61232319031', '31', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'snandhakumar304@gmail.com', '9342112294', 'Active', NOW(), NOW()
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

    -- Student #32: Nandhitha J (61232319032) | Username: nandhithaj | Password: nandhithaj32
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('nandhithaj', 'jsnandhitha2005@gmail.com', crypt('nandhithaj32', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Nandhitha J', '61232319032', '32', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'jsnandhitha2005@gmail.com', '8668075320', 'Active', NOW(), NOW()
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

    -- Student #33: Nivetha D (61232319034) | Username: nivethad | Password: nivethad34
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('nivethad', 'aishukkutty2407@gmail.com', crypt('nivethad34', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Nivetha D', '61232319034', '33', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'aishukkutty2407@gmail.com', '8248925383', 'Active', NOW(), NOW()
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

    -- Student #34: Omprakash S (61232319035) | Username: omprakashs | Password: omprakashs35
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('omprakashs', 'prakashprakash1232005@gmail.com', crypt('omprakashs35', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Omprakash S', '61232319035', '34', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'prakashprakash1232005@gmail.com', '8072960520', 'Active', NOW(), NOW()
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

    -- Student #35: Oviya S (61232319037) | Username: oviyas | Password: oviyas37
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('oviyas', 'oviyasankar2006@gmail.com', crypt('oviyas37', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Oviya S', '61232319037', '35', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'oviyasankar2006@gmail.com', '6381677123', 'Active', NOW(), NOW()
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

    -- Student #36: Pooja bharani.S (61232319035-36) | Username: poojabharanis | Password: poojabharanis36
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('poojabharanis', 'poojabharani2005@gmail.com', crypt('poojabharanis36', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Pooja bharani.S', '61232319035-36', '36', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'poojabharani2005@gmail.com', '9842588530', 'Active', NOW(), NOW()
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

    -- Student #37: Prabhavathi u (61232319037-37) | Username: prabhavathiu | Password: prabhavathiu37
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('prabhavathiu', 'prabhaudhaya897@gmail.com', crypt('prabhavathiu37', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Prabhavathi u', '61232319037-37', '37', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'prabhaudhaya897@gmail.com', '8072004721', 'Active', NOW(), NOW()
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

    -- Student #38: Pranav K (61232319038) | Username: pranavk | Password: pranavk38
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('pranavk', 'saipranav638@gmail.com', crypt('pranavk38', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Pranav K', '61232319038', '38', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'saipranav638@gmail.com', '9159983708', 'Active', NOW(), NOW()
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

    -- Student #39: Harshini R (61232319040) | Username: harshinir | Password: harshinir40
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('harshinir', 'harshini.latha2006@gmail.com', crypt('harshinir40', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Harshini R', '61232319040', '39', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'harshini.latha2006@gmail.com', '7402009087', 'Active', NOW(), NOW()
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

    -- Student #40: Parthasharathy R (61232319019) | Username: parthasharathyr | Password: parthasharathyr19
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('parthasharathyr', 'parthasharathy87@gmail.com', crypt('parthasharathyr19', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Parthasharathy R', '61232319019', '40', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'parthasharathy87@gmail.com', '9345703250', 'Active', NOW(), NOW()
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

    -- Student #41: Rajamanikandan (61232319036) | Username: rajamanikandan | Password: rajamanikandan36
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('rajamanikandan', 'havocjerry0@gmail.com', crypt('rajamanikandan36', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Rajamanikandan', '61232319036', '41', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'havocjerry0@gmail.com', '8667026602', 'Active', NOW(), NOW()
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

    -- Student #42: Ram kumar R (61232319041) | Username: ramkumarr | Password: ramkumarr41
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('ramkumarr', 'ramkumarraja827@gmail.com', crypt('ramkumarr41', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Ram kumar R', '61232319041', '42', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'ramkumarraja827@gmail.com', '9042848245', 'Active', NOW(), NOW()
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

    -- Student #43: Ramachandran k (61232319042) | Username: ramachandrank | Password: ramachandrank42
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('ramachandrank', 'ramachandran7125@gmail.com', crypt('ramachandrank42', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Ramachandran k', '61232319042', '43', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'ramachandran7125@gmail.com', '9025042174', 'Active', NOW(), NOW()
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

    -- Student #44: Pradeepa S (61232319043) | Username: pradeepas | Password: pradeepas43
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('pradeepas', 'pradeepasenthilkumar89@gmail.com', crypt('pradeepas43', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Pradeepa S', '61232319043', '44', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'pradeepasenthilkumar89@gmail.com', '9345744342', 'Active', NOW(), NOW()
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

    -- Student #45: Sakthivel R (61232319039) | Username: sakthivelr | Password: sakthivelr39
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('sakthivelr', 'sakthivelr2911@gmail.com', crypt('sakthivelr39', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Sakthivel R', '61232319039', '45', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sakthivelr2911@gmail.com', '8838175409', 'Active', NOW(), NOW()
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

    -- Student #46: Samuel S (61232319045) | Username: samuels | Password: samuels45
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('samuels', 'imsamuel1905@gmail.com', crypt('samuels45', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Samuel S', '61232319045', '46', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'imsamuel1905@gmail.com', '9361809304', 'Active', NOW(), NOW()
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

    -- Student #47: Sanjana S (61232319046) | Username: sanjanas | Password: sanjanas46
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('sanjanas', 'sanjanasanjusan055@gmail.com', crypt('sanjanas46', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Sanjana S', '61232319046', '47', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sanjanasanjusan055@gmail.com', '8610586510', 'Active', NOW(), NOW()
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

    -- Student #48: Sanjay S (61232319047) | Username: sanjays | Password: sanjays47
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('sanjays', 'sanjaysanjayt19@gmail.com', crypt('sanjays47', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Sanjay S', '61232319047', '48', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sanjaysanjayt19@gmail.com', '8925366901', 'Active', NOW(), NOW()
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

    -- Student #49: Sanjay G (61232319049) | Username: sanjayg | Password: sanjayg49
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('sanjayg', 'g.sanjayofficial4@gmail.com', crypt('sanjayg49', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Sanjay G', '61232319049', '49', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'g.sanjayofficial4@gmail.com', '7397029212', 'Active', NOW(), NOW()
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

    -- Student #50: Saranya R (61232319048) | Username: saranyar | Password: saranyar48
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('saranyar', 'sainavi56@gmail.com', crypt('saranyar48', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Saranya R', '61232319048', '50', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sainavi56@gmail.com', '9543591512', 'Active', NOW(), NOW()
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

    -- Student #51: Selvaragavan J (61232319051) | Username: selvaragavanj | Password: selvaragavanj51
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('selvaragavanj', 'selvaragavan171025@gmail.com', crypt('selvaragavanj51', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Selvaragavan J', '61232319051', '51', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'selvaragavan171025@gmail.com', '8608213942', 'Active', NOW(), NOW()
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

    -- Student #52: Sowndar K (61232319053) | Username: sowndark | Password: sowndark53
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('sowndark', 'sowndar706@gmail.com', crypt('sowndark53', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Sowndar K', '61232319053', '52', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'sowndar706@gmail.com', '6380314133', 'Active', NOW(), NOW()
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

    -- Student #53: Subashini R (61232319054) | Username: subashinir | Password: subashinir54
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('subashinir', 'ssuba7588@gmail.com', crypt('subashinir54', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Subashini R', '61232319054', '53', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'ssuba7588@gmail.com', '9962055341', 'Active', NOW(), NOW()
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

    -- Student #54: Vikram S (61232319057) | Username: vikrams | Password: vikrams57
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('vikrams', 'vikramsnv2512@gmail.com', crypt('vikrams57', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Vikram S', '61232319057', '54', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'vikramsnv2512@gmail.com', '9150363074', 'Active', NOW(), NOW()
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

    -- Student #55: Yashwanthini KA (61232319058) | Username: yashwanthinika | Password: yashwanthinika58
    INSERT INTO users (username, email, password_hash, role, is_active, department_id, created_at, updated_at)
    VALUES ('yashwanthinika', 'yashwanthini1106@gmail.com', crypt('yashwanthinika58', gen_salt('bf', 10)), 'STUDENT', true, dept_id_val, NOW(), NOW())
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
        new_user_id, 'Yashwanthini KA', '61232319058', '55', 'Artificial intelligence and Data science', dept_id_val,
        'B.TECH', 'IV', 4, 'VII', 'yashwanthini1106@gmail.com', '9585522388', 'Active', NOW(), NOW()
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

END $$;