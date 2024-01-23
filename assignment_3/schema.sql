CREATE DATABASE as3;
USE as3;

CREATE TABLE department (
    did INT,
    dname VARCHAR(20), 
    building VARCHAR(20),
    budget NUMERIC(8, 2), 
    PRIMARY KEY (did)
);

CREATE TABLE faculty (
    fid INT,  
    fname VARCHAR(20), 
    did INT,
    salary NUMERIC(8,2),
    FOREIGN KEY (did) REFERENCES department(did),
    PRIMARY KEY (fid)
);

CREATE TABLE student (
    sid INT, 
    sname VARCHAR(20),
    age INT, 
    did INT,
    FOREIGN KEY (did) REFERENCES department(did),
    PRIMARY KEY (sid)
);

CREATE TABLE course (
    cid INT,
    cname VARCHAR(20),
    credit INT, 
    did INT,
    FOREIGN KEY (did) REFERENCES department(did),
    PRIMARY KEY (cid)
);

CREATE TABLE teaches (
    fid INT, 
    cid INT,  
    CONSTRAINT PK_teaches PRIMARY KEY (fid, cid),
    FOREIGN KEY (fid) REFERENCES faculty(fid),
    FOREIGN KEY (cid) REFERENCES course(cid)
);

CREATE TABLE takes (
    sid INT,
    cid INT,
    CONSTRAINT PK_takes PRIMARY KEY (sid, cid),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (cid) REFERENCES course(cid)
);

CREATE TABLE advisor (
    sid INT,
    fid INT,
    title VARCHAR(100),
    PRIMARY KEY (sid)
);
