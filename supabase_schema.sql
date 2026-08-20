-- ==========================================
-- SUPABASE DATABASE SCHEMA FOR CAMP CHAMP
-- ==========================================
-- Project: Camp Champ (SmartSec)
-- Supabase URL: https://exfixmqlcmsaegzuabgy.supabase.co
-- Generated: 2026-08-16
-- ==========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------
-- 0.1 DEPARTMENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.departments (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 0.2 USERS TABLE (CENTRAL AUTHENTICATION)
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'TEACHER', -- 'ADMIN', 'TEACHER', 'STUDENT', 'PARENT'
    department_id INTEGER REFERENCES public.departments(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 1. STUDENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.students (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    register_number TEXT UNIQUE NOT NULL,
    roll_number TEXT DEFAULT '',
    date_of_birth DATE,
    department TEXT NOT NULL,
    course TEXT NOT NULL,
    year TEXT NOT NULL,
    section TEXT NOT NULL,
    semester TEXT NOT NULL,
    college TEXT NOT NULL,
    location TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    attendance_percentage NUMERIC DEFAULT 0.0,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 2. TEACHERS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.teachers (
    id TEXT PRIMARY KEY,
    user_id INTEGER REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    faculty_id TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    department_id INTEGER REFERENCES public.departments(id) ON DELETE SET NULL,
    designation TEXT NOT NULL,
    degree TEXT DEFAULT 'M.Tech',
    class_advisor TEXT DEFAULT '2nd Year CSE',
    subjects TEXT[] DEFAULT '{}',
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    college TEXT NOT NULL,
    location TEXT NOT NULL,
    is_present BOOLEAN DEFAULT true,
    attendance_percentage NUMERIC DEFAULT 96.5,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 2.1 FACULTY ACCOUNT REQUESTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.faculty_account_requests (
    id TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    employee_id TEXT NOT NULL,
    department TEXT NOT NULL,
    designation TEXT NOT NULL,
    degree TEXT DEFAULT 'M.Tech',
    username TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    status TEXT DEFAULT 'PENDING',
    rejection_reason TEXT,
    reviewed_by TEXT,
    requested_at TIMESTAMPTZ DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 3. PARENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.parents (
    id TEXT PRIMARY KEY,
    parent_id TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    relationship TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    emergency_contact TEXT DEFAULT '+91 90000 00099',
    address TEXT DEFAULT 'No. 42, Main Road, Tiruchengode, Tamil Nadu',
    children_ids TEXT[] DEFAULT '{}',
    student_id TEXT REFERENCES public.students(id) ON DELETE SET NULL,
    student_name TEXT NOT NULL,
    register_number TEXT NOT NULL,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 4. ADMINS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.admins (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL,
    designation TEXT DEFAULT 'Administrator',
    college TEXT NOT NULL,
    location TEXT NOT NULL,
    avatar_url TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 5. ANNOUNCEMENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    date TEXT NOT NULL,
    audience TEXT DEFAULT 'All', -- 'All', 'Students', 'Teachers', 'Parents'
    status TEXT DEFAULT 'Published',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 6. ASSIGNMENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id TEXT REFERENCES public.teachers(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    subject TEXT NOT NULL,
    class_name TEXT NOT NULL,
    description TEXT,
    questions TEXT,
    assigned_date TEXT NOT NULL,
    due_date TEXT NOT NULL,
    maximum_marks INTEGER DEFAULT 100,
    status TEXT DEFAULT 'Active',
    submissions_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 7. ATTENDANCE RECORDS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.attendance_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id TEXT REFERENCES public.students(id) ON DELETE CASCADE,
    student_name TEXT NOT NULL,
    register_number TEXT NOT NULL,
    teacher_id TEXT REFERENCES public.teachers(id) ON DELETE SET NULL,
    class_id TEXT NOT NULL,
    subject_id TEXT NOT NULL,
    subject_name TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    status TEXT NOT NULL, -- 'present', 'absent', 'notMarked'
    sms_sent BOOLEAN DEFAULT false,
    sms_sent_at TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 8. FEE PAYMENTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.fee_payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id TEXT REFERENCES public.students(id) ON DELETE CASCADE,
    student_name TEXT NOT NULL,
    register_number TEXT NOT NULL,
    department TEXT NOT NULL,
    year TEXT NOT NULL,
    academic_year TEXT NOT NULL,
    total_fees NUMERIC NOT NULL,
    paid_amount NUMERIC NOT NULL,
    pending_amount NUMERIC NOT NULL,
    due_date TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL, -- 'paid', 'pending', 'partiallyPaid', 'overdue'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 9. FEE TRANSACTIONS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.fee_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fee_payment_id UUID REFERENCES public.fee_payments(id) ON DELETE CASCADE,
    transaction_id TEXT UNIQUE NOT NULL,
    amount NUMERIC NOT NULL,
    date TIMESTAMPTZ DEFAULT NOW(),
    status TEXT DEFAULT 'SUCCESS',
    payment_method TEXT DEFAULT 'Demo Online Payment',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 10. MARKS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.marks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id TEXT REFERENCES public.students(id) ON DELETE CASCADE,
    subject_code TEXT NOT NULL,
    subject_name TEXT NOT NULL,
    cia1 NUMERIC DEFAULT 0,
    cia2 NUMERIC DEFAULT 0,
    cia3 NUMERIC DEFAULT 0,
    max_marks NUMERIC DEFAULT 100,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 11. TIMETABLE ENTRIES TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.timetable_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    department TEXT DEFAULT 'CSE',
    year TEXT DEFAULT '2nd Year',
    day TEXT NOT NULL, -- 'Monday', 'Tuesday', etc.
    period TEXT NOT NULL,
    time_slot TEXT NOT NULL,
    subject TEXT NOT NULL,
    faculty TEXT NOT NULL,
    room TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 12. ONLINE CLASSES TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.online_classes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id TEXT REFERENCES public.teachers(id) ON DELETE CASCADE,
    subject TEXT NOT NULL,
    class_name TEXT NOT NULL,
    date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    platform TEXT DEFAULT 'Google Meet',
    meeting_url TEXT,
    description TEXT,
    status TEXT DEFAULT 'UPCOMING', -- 'LIVE', 'UPCOMING', 'COMPLETED'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------
-- 13. PARENT TEACHER MEETINGS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.parent_teacher_meetings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id TEXT REFERENCES public.parents(id) ON DELETE CASCADE,
    student_id TEXT REFERENCES public.students(id) ON DELETE CASCADE,
    student_name TEXT NOT NULL,
    register_number TEXT NOT NULL,
    teacher_id TEXT REFERENCES public.teachers(id) ON DELETE CASCADE,
    teacher_name TEXT NOT NULL,
    subject TEXT NOT NULL,
    date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    status TEXT DEFAULT 'requested', -- 'requested', 'confirmed', 'rejected', 'cancelled', 'completed'
    meeting_type TEXT DEFAULT 'Online - Google Meet',
    notes TEXT,
    meeting_link TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- INDEXES FOR PERFORMANCE
-- ==========================================
CREATE INDEX IF NOT EXISTS idx_students_reg_no ON public.students(register_number);
CREATE INDEX IF NOT EXISTS idx_teachers_faculty_id ON public.teachers(faculty_id);
CREATE INDEX IF NOT EXISTS idx_parents_parent_id ON public.parents(parent_id);
CREATE INDEX IF NOT EXISTS idx_attendance_student_id ON public.attendance_records(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON public.attendance_records(date);
CREATE INDEX IF NOT EXISTS idx_assignments_teacher_id ON public.assignments(teacher_id);
CREATE INDEX IF NOT EXISTS idx_marks_student_id ON public.marks(student_id);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fee_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fee_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.timetable_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.online_classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_teacher_meetings ENABLE ROW LEVEL SECURITY;

-- Allow Public / Anon Access for Demo Read & Write
CREATE POLICY "Allow public select on students" ON public.students FOR SELECT USING (true);
CREATE POLICY "Allow public insert/update on students" ON public.students FOR ALL USING (true);

CREATE POLICY "Allow public select on teachers" ON public.teachers FOR SELECT USING (true);
CREATE POLICY "Allow public insert/update on teachers" ON public.teachers FOR ALL USING (true);

CREATE POLICY "Allow public select on parents" ON public.parents FOR SELECT USING (true);
CREATE POLICY "Allow public insert/update on parents" ON public.parents FOR ALL USING (true);

CREATE POLICY "Allow public select on admins" ON public.admins FOR SELECT USING (true);
CREATE POLICY "Allow public insert/update on admins" ON public.admins FOR ALL USING (true);

CREATE POLICY "Allow public select on announcements" ON public.announcements FOR SELECT USING (true);
CREATE POLICY "Allow public insert on announcements" ON public.announcements FOR ALL USING (true);

CREATE POLICY "Allow public select on assignments" ON public.assignments FOR SELECT USING (true);
CREATE POLICY "Allow public insert on assignments" ON public.assignments FOR ALL USING (true);

CREATE POLICY "Allow public select on attendance_records" ON public.attendance_records FOR SELECT USING (true);
CREATE POLICY "Allow public insert on attendance_records" ON public.attendance_records FOR ALL USING (true);

CREATE POLICY "Allow public select on fee_payments" ON public.fee_payments FOR SELECT USING (true);
CREATE POLICY "Allow public all on fee_payments" ON public.fee_payments FOR ALL USING (true);

CREATE POLICY "Allow public select on fee_transactions" ON public.fee_transactions FOR SELECT USING (true);
CREATE POLICY "Allow public all on fee_transactions" ON public.fee_transactions FOR ALL USING (true);

CREATE POLICY "Allow public select on marks" ON public.marks FOR SELECT USING (true);
CREATE POLICY "Allow public all on marks" ON public.marks FOR ALL USING (true);

CREATE POLICY "Allow public select on timetable_entries" ON public.timetable_entries FOR SELECT USING (true);
CREATE POLICY "Allow public all on timetable_entries" ON public.timetable_entries FOR ALL USING (true);

CREATE POLICY "Allow public select on online_classes" ON public.online_classes FOR SELECT USING (true);
CREATE POLICY "Allow public all on online_classes" ON public.online_classes FOR ALL USING (true);

CREATE POLICY "Allow public select on parent_teacher_meetings" ON public.parent_teacher_meetings FOR SELECT USING (true);
CREATE POLICY "Allow public all on parent_teacher_meetings" ON public.parent_teacher_meetings FOR ALL USING (true);

-- ==========================================
-- SAMPLE SEED DATA
-- ==========================================

-- 1. Insert Demo Student
INSERT INTO public.students (id, name, register_number, department, course, year, section, semester, college, location, email, phone, attendance_percentage, status)
VALUES (
    'SEC2024001',
    'Duraimurugan M',
    'SEC2024001',
    'Computer Science & Engineering',
    'B.E. CSE',
    '2nd Year',
    'A',
    'Semester IV',
    'Sengunthar Engineering College',
    'Tiruchengode, Tamil Nadu',
    'student@smartsec.demo',
    '+91 98765 43210',
    92.5,
    'Active'
) ON CONFLICT (register_number) DO NOTHING;

-- 2. Insert Demo Teacher
INSERT INTO public.teachers (id, name, faculty_id, department, designation, class_advisor, subjects, email, phone, college, location, is_present, attendance_percentage, status)
VALUES (
    'SEC-TCH-001',
    'Dr. Ravi Kumar',
    'SEC-TCH-001',
    'Computer Science & Engineering',
    'Associate Professor',
    '2nd Year CSE - A',
    ARRAY['Data Structures', 'Database Systems', 'Operating Systems'],
    'teacher@smartsec.demo',
    '+91 98765 12345',
    'Sengunthar Engineering College',
    'Tiruchengode, Tamil Nadu',
    true,
    96.5,
    'Active'
) ON CONFLICT (faculty_id) DO NOTHING;

-- 3. Insert Demo Parent
INSERT INTO public.parents (id, parent_id, name, relationship, phone, email, emergency_contact, address, children_ids, student_id, student_name, register_number, status)
VALUES (
    'SEC-PAR-001',
    'SEC-PAR-001',
    'Murugan S',
    'Father',
    '+91 94433 22110',
    'parent@smartsec.demo',
    '+91 90000 00099',
    'No. 42, Main Road, Tiruchengode, Tamil Nadu',
    ARRAY['SEC2024001'],
    'SEC2024001',
    'Duraimurugan M',
    'SEC2024001',
    'Active'
) ON CONFLICT (parent_id) DO NOTHING;

-- 4. Insert Demo Admins
INSERT INTO public.admins (id, name, email, role, designation, college, location, avatar_url)
VALUES 
(
    'SEC-ADM-001',
    'Principal / Admin Office',
    'admin@smartsec.demo',
    'System Administrator',
    'Chief Academic Officer',
    'Sengunthar Engineering College',
    'Tiruchengode, Tamil Nadu',
    ''
),
(
    'SEC-AIDS-HOD',
    'Dr. Santhipriya',
    'santhipriyahod@gmail.com',
    'HOD - AI & Data Science',
    'Head of Department (AIDS)',
    'Sengunthar Engineering College',
    'Tiruchengode, Tamil Nadu',
    ''
) ON CONFLICT (email) DO NOTHING;

-- 14. FACULTY ACCOUNT REQUESTS TABLE
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS public.faculty_account_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    employee_id TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    designation TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    status TEXT DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    requested_at TIMESTAMPTZ DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,
    reviewed_by TEXT,
    rejection_reason TEXT
);

ALTER TABLE public.faculty_account_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public select on faculty_account_requests" ON public.faculty_account_requests FOR SELECT USING (true);
CREATE POLICY "Allow public insert on faculty_account_requests" ON public.faculty_account_requests FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on faculty_account_requests" ON public.faculty_account_requests FOR UPDATE USING (true);

-- 5. Insert Demo Announcements
INSERT INTO public.announcements (title, content, date, audience, status)
VALUES 
('CIA Test 3 Schedule Released', 'The CIA 3 examination for 2nd Year CSE will begin from Monday.', '16 Aug 2026', 'Students', 'Published'),
('Parent Teacher Meeting Announced', 'Annual PTM meeting scheduled for this weekend. Request slots via the app.', '15 Aug 2026', 'Parents', 'Published'),
('Faculty Meeting at 4:00 PM', 'All HODs and faculty members assemble at Conference Hall B.', '14 Aug 2026', 'Teachers', 'Published');

-- 6. Insert Demo Timetable
INSERT INTO public.timetable_entries (day, period, time_slot, subject, faculty, room)
VALUES 
('Monday', '1st Period', '09:00 AM - 10:00 AM', 'Database Management Systems', 'Dr. Ravi Kumar', 'Lab 3'),
('Monday', '2nd Period', '10:00 AM - 11:00 AM', 'Operating Systems', 'Prof. Anitha M', 'Hall 204'),
('Monday', '3rd Period', '11:15 AM - 12:15 PM', 'Computer Networks', 'Dr. Suresh P', 'Lab 1'),
('Tuesday', '1st Period', '09:00 AM - 10:00 AM', 'Data Structures & Algorithms', 'Dr. Ravi Kumar', 'Lab 3');
