-- table 'salary'

INSERT INTO topic_3.salary VALUES('Ken Sánchez', 'HR', 78);
INSERT INTO topic_3.salary VALUES('TerriLee Duffy', 'HR', 95);
INSERT INTO topic_3.salary VALUES('Roberto Tamburello', 'HR', 382);
INSERT INTO topic_3.salary VALUES('Rob Walters', 'HR', 16);
INSERT INTO topic_3.salary VALUES('Gail Erickson', 'HR', 1079);
INSERT INTO topic_3.salary VALUES('Jossef Gibson', 'HR', 102);
INSERT INTO topic_3.salary VALUES('Dylan Miller', 'HR', 486);
INSERT INTO topic_3.salary VALUES('Diane Margheim', 'HR', 1953);
INSERT INTO topic_3.salary VALUES('Gigi Matthew', 'SALE', 49);
INSERT INTO topic_3.salary VALUES('Michael Raheem', 'SALE', 71);
INSERT INTO topic_3.salary VALUES('Ovidiu Cracium', 'SALE', 94);
INSERT INTO topic_3.salary VALUES('Thierry Hers', 'SALE', 61);
INSERT INTO topic_3.salary VALUES('Janice Galvin', 'SALE', 972);
INSERT INTO topic_3.salary VALUES('Michael Sullivan', 'SALE', 849);
INSERT INTO topic_3.salary VALUES('Sharon Salavaria', 'SALE', 715);
INSERT INTO topic_3.salary VALUES('David Michael', 'SALE', 94);
INSERT INTO topic_3.salary VALUES('Kevin Brown', 'R&D', 891);
INSERT INTO topic_3.salary VALUES('John Wood', 'R&D', 1486);
INSERT INTO topic_3.salary VALUES('Mary Dempsey', 'R&D', 176);
INSERT INTO topic_3.salary VALUES('Wanida Benshoof', 'R&D', 49);
INSERT INTO topic_3.salary VALUES('Terry Eminhizer', 'R&D', 381);
INSERT INTO topic_3.salary VALUES('Sariya Harnpadoungsataya', 'R&D', 946);
INSERT INTO topic_3.salary VALUES('Mary Gibson', 'R&D', 486);
INSERT INTO topic_3.salary VALUES('Jill Williams', 'R&D', 19);
INSERT INTO topic_3.salary VALUES('James Hamilton', 'R&D', 46);
INSERT INTO topic_3.salary VALUES('Peter Krebs', 'R&D', 445);
INSERT INTO topic_3.salary VALUES('Jo Brown', 'R&D', 666) ;
INSERT INTO topic_3.salary VALUES('Guy Gilbert', 'MANAGEMENT', 482);
INSERT INTO topic_3.salary VALUES('Mark McArthur', 'MANAGEMENT', 12);
INSERT INTO topic_3.salary VALUES('Britta Simon', 'MANAGEMENT', 194);
INSERT INTO topic_3.salary VALUES('Margie Shoop', 'MANAGEMENT', 481);
INSERT INTO topic_3.salary VALUES('Rebecca Laszlo', 'MANAGEMENT', 16);
INSERT INTO topic_3.salary VALUES('Annik Stahl', 'MANAGEMENT', 134);
INSERT INTO topic_3.salary VALUES('Suchitra Mohan', 'R&D', 87);
INSERT INTO topic_3.salary VALUES('Brandon Heidepriem', 'R&D', 111) ;
INSERT INTO topic_3.salary VALUES('Jose Lugo', 'R&D', 185);
INSERT INTO topic_3.salary VALUES('Chris Okelberry', 'R&D', 94);
INSERT INTO topic_3.salary VALUES('Kim Abercrombie', 'R&D', 348);
INSERT INTO topic_3.salary VALUES('Ed Dudenhoefer', 'R&D', 68);
INSERT INTO topic_3.salary VALUES('JoLynn Dobney', 'R&D', 346);
INSERT INTO topic_3.salary VALUES('Bryan Baker', 'R&D', 185);
INSERT INTO topic_3.salary VALUES('James Kramer', 'SUPPORT', 965);
INSERT INTO topic_3.salary VALUES('Nancy Anderson', 'SUPPORT', 444);
INSERT INTO topic_3.salary VALUES('Simon Rapier', 'SUPPORT', 133);
INSERT INTO topic_3.salary VALUES('Thomas Michaels', 'SUPPORT', 200);
INSERT INTO topic_3.salary VALUES('Eugene Kogan', 'SUPPORT', 144);
INSERT INTO topic_3.salary VALUES('Andrew Hill', 'SUPPORT', 186);
INSERT INTO topic_3.salary VALUES('Ruth Ellerbrock', 'SUPPORT', 179);
INSERT INTO topic_3.salary VALUES('Barry Johnson', 'HEAD', 10000);
INSERT INTO topic_3.salary VALUES('Sidney Higa', 'HEAD', 1);
INSERT INTO topic_3.salary VALUES('Max Lanson', 'PR', 150);

-- table 'department'

INSERT INTO topic_3.department VALUES('HR', 'Murom');
INSERT INTO topic_3.department VALUES('SUPPORT', 'Saratov');
INSERT INTO topic_3.department VALUES('MANAGEMENT', 'Samara');
INSERT INTO topic_3.department VALUES('HEAD', 'Moscow');
INSERT INTO topic_3.department VALUES('SALE', 'Moscow');
INSERT INTO topic_3.department VALUES('R&D', 'Novosibirsk');

-- table 'db_instructor_salary'

DROP TABLE IF EXISTS topic_3.db_instructor_salary;
CREATE TABLE topic_3.db_instructor_salary (
    name        VARCHAR(120),
    dt          DATE,
    salary_amt  DECIMAL(12, 2),
    salary_type SMALLINT
);

INSERT INTO topic_3.db_instructor_salary VALUES ('Роздухова Нина', '2019-02-25', 2999.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Роздухова Нина', '2019-03-05', 5100.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Роздухова Нина', '2019-03-05', 6800.00, 3);
INSERT INTO topic_3.db_instructor_salary VALUES ('Халяпов Александр', '2019-02-25', 10499.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Халяпов Александр', '2019-03-05', 13000.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Меркурьева Надежда', '2019-02-25', 2999.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Меркурьева Надежда', '2019-02-25', 5800.00, 2);
INSERT INTO topic_3.db_instructor_salary VALUES ('Меркурьева Надежда', '2019-03-05', 6400.00, 1);
INSERT INTO topic_3.db_instructor_salary VALUES ('Меркурьева Надежда', '2019-03-05', 8300.00, 2);
