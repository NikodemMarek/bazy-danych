CREATE USER admin WITH PASSWORD :'admin_pass';
GRANT group_admin TO admin;

CREATE USER application WITH PASSWORD :'application_pass';
GRANT group_application TO application;

CREATE USER analyst WITH PASSWORD :'analyst_pass';
GRANT group_analyst TO analyst;