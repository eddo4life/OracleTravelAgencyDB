connect user/password;

/*DROP TABLESPACE TS_TABLE_AGENCE INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_index_agence INCLUDING CONTENTS AND DATAFILES;
DROP USER agenceuser CASCADE;*/


--Creation du TableSpace (TS_TABLE_AGENCE) pour le stockage de nos tables
CREATE TABLESPACE TS_TABLE_AGENCE
 DATAFILE 'path\to\TS_TABLE_AGENCE.dbf'
 SIZE 10M
 EXTENT MANAGEMENT LOCAL AUTOALLOCATE
 SEGMENT SPACE MANAGEMENT AUTO;

--Creation du TableSpace (ts_index_agence) pour le stockage des index
CREATE TABLESPACE TS_INDEX_AGENCE
 DATAFILE 'path\to\ts_index_agence.dbf'
 SIZE 5M
 EXTENT MANAGEMENT LOCAL AUTOALLOCATE
 SEGMENT SPACE MANAGEMENT AUTO;

--Créer un utilisateur de votre choix qui sera propriétaire de votre
--application. Les segments temporaires doivent être localisés dans le tablespace
--approprié créé précédement. Vous devez lui donner les droits appropriés

--Creation de L'utilisateur
CREATE USER AGENCEUSER IDENTIFIED BY password
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

-- Droit d'administration de l'Utilisateur sur la base
GRANT DBA TO AGENCEUSER;

--Donner les droits d'ecriture sur les tablespaces
ALTER USER AGENCEUSER QUOTA UNLIMITED ON USERS QUOTA UNLIMITED ON TS_TABLE_AGENCE QUOTA UNLIMITED ON TS_INDEX_AGENCE;

--CONNECT avec l'utilisateur
CONNECT AGENCEUSER/password

-- Création des tables avec le calcul volumetrique de chaque Table

--====================== Clients ==========================--
--DBMS_SPACE

SET SERVEROUTPUT ON

DECLARE
    C_USED_BYTES      NUMBER(10);
    C_ALLOCATED_BYTES NUMBER(10);
    C_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    C_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('DATE', NULL), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 20), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', C_TYPE, 50, 10, C_USED_BYTES, C_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(C_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(C_ALLOCATED_BYTES));
END;
/

-- 65536 Octects = 64K
CREATE TABLE CLIENTS (
    CLIENTID NUMBER(7),
    NOM VARCHAR2(255) NOT NULL,
    PRENOM VARCHAR2(255) NOT NULL,
    DATENAISSANCE DATE NOT NULL,
    EMAIL VARCHAR2(255) NOT NULL UNIQUE,
    TELEPHONE VARCHAR2(20) NOT NULL,
    ADRESSE VARCHAR2(255) NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 65K NEXT 65K PCTINCREASE 0 MINEXTENTS 1
);

--================== Agence ==============================--

SET SERVEROUTPUT ON

DECLARE
    AG_USED_BYTES      NUMBER(10);
    AG_ALLOCATED_BYTES NUMBER(10);
    AG_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    AG_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 20), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 255) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', AG_TYPE, 10, 10, AG_USED_BYTES, AG_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(AG_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(AG_ALLOCATED_BYTES));
END;
/

-- 65536 = 64K
CREATE TABLE AGENCE (
    SURCUSSALID NUMBER(7),
    NOMSURCUSSAL VARCHAR2(255) NOT NULL,
    ADRESSE VARCHAR2(255) NOT NULL,
    TELEPHONE VARCHAR2(20) NOT NULL,
    EMAIL VARCHAR2(255) NOT NULL UNIQUE
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--================== OriginesDestinations ==============================--
SET SERVEROUTPUT ON

DECLARE
    OD_USED_BYTES      NUMBER(10);
    OD_ALLOCATED_BYTES NUMBER(10);
    OD_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    OD_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 100), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 100) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', OD_TYPE, 20, 10, OD_USED_BYTES, OD_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(OD_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(OD_ALLOCATED_BYTES));
END;
/

-- 65536 = 64K
CREATE TABLE ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID NUMBER,
    PAYS VARCHAR2(100) NOT NULL,
    VILLE VARCHAR2(100) NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 65K NEXT 65K PCTINCREASE 0 MINEXTENTS 1
);

--================== Moyen Transport ==============================--
SET SERVEROUTPUT ON

DECLARE
    MT_USED_BYTES      NUMBER(10);
    MT_ALLOCATED_BYTES NUMBER(10);
    MT_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    MT_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', MT_TYPE, 50, 10, MT_USED_BYTES, MT_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(MT_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(MT_ALLOCATED_BYTES));
END;
/

-- 65536 = 64K
CREATE TABLE MOYENTRANSPORT (
    MOYENID NUMBER,
    TYPE VARCHAR2(255) NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--==================== Voyage ============================--
SET SERVEROUTPUT ON

DECLARE
    V_USED_BYTES      NUMBER(10);
    V_ALLOCATED_BYTES NUMBER(10);
    V_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    V_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('DATE', NULL), SYS.CREATE_TABLE_COST_COLINFO('DATE', NULL) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', V_TYPE, 50, 10, V_USED_BYTES, V_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(V_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(V_ALLOCATED_BYTES));
END;
/

-- 65536 = 64K -- (1) --
CREATE TABLE VOYAGES (
    VOYAGEID NUMBER,
    ORIGINEID NUMBER NOT NULL,
    DESTINATIONID NUMBER NOT NULL,
    MOYENID NUMBER NOT NULL,
    DATEDEPART DATE NOT NULL,
    DATERETOUR DATE NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--================== Agents ==============================--

SET SERVEROUTPUT ON

DECLARE
    A_USED_BYTES      NUMBER(10);
    A_ALLOCATED_BYTES NUMBER(10);
    A_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    A_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 255), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR2', 20) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', A_TYPE, 50, 10, A_USED_BYTES, A_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(A_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(A_ALLOCATED_BYTES));
END;
/

-- 64K
CREATE TABLE AGENTS (
    AGENTID NUMBER,
    SURCUSSALID NUMBER NOT NULL,
    NOM VARCHAR2(255) NOT NULL,
    PRENOM VARCHAR2(255) NOT NULL,
    EMAIL VARCHAR2(255) NOT NULL UNIQUE,
    TELEPHONE VARCHAR2(20) NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--====================== Reservation ==========================--

SET SERVEROUTPUT ON

DECLARE
    R_USED_BYTES      NUMBER(10);
    R_ALLOCATED_BYTES NUMBER(10);
    R_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    R_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('DATE', NULL), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 10), SYS.CREATE_TABLE_COST_COLINFO('NUMBER(1)', 0) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', R_TYPE, 50, 10, R_USED_BYTES, R_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(R_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(R_ALLOCATED_BYTES));
END;
/

-- 65536 = 64K
CREATE TABLE RESERVATIONS (
    RESERVATIONID NUMBER,
    CLIENTID NUMBER NOT NULL,
    VOYAGEID NUMBER NOT NULL,
    SURCUSSALID NUMBER NOT NULL,
    AGENTID NUMBER NOT NULL,
    DATERESERVATION DATE NOT NULL,
    MONTANTTOTAL NUMBER NOT NULL,
    ALLERRETOUR NUMBER(1) DEFAULT 0 CHECK (ALLERRETOUR IN (0, 1))
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--================== Paiements ==============================--
SET SERVEROUTPUT ON

DECLARE
    P_USED_BYTES      NUMBER(10);
    P_ALLOCATED_BYTES NUMBER(10);
    P_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    P_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('VARCHAR', 255) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', P_TYPE, 50, 10, P_USED_BYTES, P_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(P_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(P_ALLOCATED_BYTES));
END;
/

-- 65336 = 64K
CREATE TABLE PAIEMENTS (
    PAIEMENTID NUMBER,
    RESERVATIONID NUMBER NOT NULL,
    MODEPAIEMENT VARCHAR2(100) NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1
);

--=================== VoyageMoyenTransport =============================--
SET SERVEROUTPUT ON

DECLARE
    VM_USED_BYTES      NUMBER(10);
    VM_ALLOCATED_BYTES NUMBER(10);
    VM_TYPE            SYS.CREATE_TABLE_COST_COLUMNS;
BEGIN
    VM_TYPE := SYS.CREATE_TABLE_COST_COLUMNS( SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('NUMBER', 7), SYS.CREATE_TABLE_COST_COLINFO('DATE', NULL) );
    DBMS_SPACE.CREATE_TABLE_COST('TS_TABLE_AGENCE', VM_TYPE, 50, 10, VM_USED_BYTES, VM_ALLOCATED_BYTES);
    DBMS_OUTPUT.PUT_LINE('Used Bytes : '
                         || TO_CHAR(VM_USED_BYTES)
                         || ' Allocated Bytes : '
                         || TO_CHAR(VM_ALLOCATED_BYTES));
END;
/

--65536 = 64K

CREATE TABLE VOYAGEMOYENTRANSPORT(
    VOYAGEID NUMBER NOT NULL,
    MOYENID NUMBER NOT NULL,
    PRIX NUMBER NOT NULL
)TABLESPACE TS_TABLE_AGENCE STORAGE(
    INITIAL 65K NEXT 65K PCTINCREASE 0 MINEXTENTS 1
);

-- Définition des contraintes cles primaires

ALTER TABLE CLIENTS
    ADD CONSTRAINT PK_CLIENTS PRIMARY KEY (
        CLIENTID
    );

ALTER TABLE AGENCE
    ADD CONSTRAINT PK_AGENCE PRIMARY KEY (
        SURCUSSALID
    );

ALTER TABLE ORIGINESDESTINATIONS
    ADD CONSTRAINT PK_ORDESTINATIONS PRIMARY KEY (
        ORIGINEDESTINATIONID
    );

ALTER TABLE MOYENTRANSPORT
    ADD CONSTRAINT PK_MOYENTRANSPORT PRIMARY KEY (
        MOYENID
    );

ALTER TABLE VOYAGES
    ADD CONSTRAINT PK_VOYAGES PRIMARY KEY (
        VOYAGEID
    );

ALTER TABLE AGENTS
    ADD CONSTRAINT PK_AGENTS PRIMARY KEY (
        AGENTID
    );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT PK_RESERVATIONS PRIMARY KEY (
        RESERVATIONID
    );

ALTER TABLE PAIEMENTS
    ADD CONSTRAINT PK_PAIEMENTS PRIMARY KEY (
        PAIEMENTID
    );

ALTER TABLE VOYAGEMOYENTRANSPORT
    ADD CONSTRAINT PK_VOYAGEMOYENTRANSPORT PRIMARY KEY (
        VOYAGEID,
        MOYENID
    );

-- Définition des contraintes et index

-- Ajout des contraintes CHECK

ALTER TABLE CLIENTS
    ADD CONSTRAINT CHK_EMAIL_CLIENTS CHECK (
        INSTR(EMAIL, '@') > 0
    );

ALTER TABLE AGENCE
    ADD CONSTRAINT CHK_AGENCE_EMAIL CHECK (
        INSTR(EMAIL, '@') > 0
    );

ALTER TABLE MOYENTRANSPORT
    ADD CONSTRAINT CHK_MOYENTRANSPORT_TYPE CHECK (
        TYPE IN ('Bus', 'Avion', 'Jet Prive', 'Taxi')
    );

ALTER TABLE VOYAGES
    ADD CONSTRAINT CHK_VOYAGES_DATES CHECK (
        DATEDEPART <= DATERETOUR
    );

ALTER TABLE AGENTS
    ADD CONSTRAINT CHK_AGENTS_EMAIL CHECK (
        INSTR(EMAIL, '@') > 0
    );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT CHK_RESERVATIONS_MONTANT CHECK (
        MONTANTTOTAL >= 0
    );

ALTER TABLE PAIEMENTS
    ADD CONSTRAINT CHK_PAIEMENTS_MODE CHECK (
        MODEPAIEMENT IN ('paypal', 'cash', 'visa')
    );

ALTER TABLE VOYAGEMOYENTRANSPORT
    ADD CONSTRAINT CHK_VOYAGEMOYENTRANSPORT_PRIX CHECK (
        PRIX >= 0
    );

-- Ajout des contraintes de clé étrangère

ALTER TABLE VOYAGES
    ADD CONSTRAINT FK_VOYAGES_ORIGINES FOREIGN KEY (
        ORIGINEID
    )
        REFERENCES ORIGINESDESTINATIONS (
            ORIGINEDESTINATIONID
        );

ALTER TABLE VOYAGES
    ADD CONSTRAINT FK_VOYAGES_DESTINATIONS FOREIGN KEY (
        DESTINATIONID
    )
        REFERENCES ORIGINESDESTINATIONS (
            ORIGINEDESTINATIONID
        );

ALTER TABLE VOYAGES
    ADD CONSTRAINT FK_VOYAGES_MOYENTRANSPORT FOREIGN KEY (
        MOYENID
    )
        REFERENCES MOYENTRANSPORT (
            MOYENID
        );

ALTER TABLE AGENTS
    ADD CONSTRAINT FK_AGENTS_AGENCE FOREIGN KEY (
        SURCUSSALID
    )
        REFERENCES AGENCE (
            SURCUSSALID
        );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT FK_RESERVATIONS_CLIENTS FOREIGN KEY (
        CLIENTID
    )
        REFERENCES CLIENTS (
            CLIENTID
        );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT FK_RESERVATIONS_VOYAGES FOREIGN KEY (
        VOYAGEID
    )
        REFERENCES VOYAGES (
            VOYAGEID
        );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT FK_RESERVATIONS_AGENCE FOREIGN KEY (
        SURCUSSALID
    )
        REFERENCES AGENCE (
            SURCUSSALID
        );

ALTER TABLE RESERVATIONS
    ADD CONSTRAINT FK_RESERVATIONS_AGENTS FOREIGN KEY (
        AGENTID
    )
        REFERENCES AGENTS (
            AGENTID
        );

ALTER TABLE PAIEMENTS
    ADD CONSTRAINT FK_PAIEMENTS_RESERVATIONS FOREIGN KEY (
        RESERVATIONID
    )
        REFERENCES RESERVATIONS (
            RESERVATIONID
        );

ALTER TABLE VOYAGEMOYENTRANSPORT
    ADD CONSTRAINT FK_VMTRANS_V FOREIGN KEY (
        VOYAGEID
    )
        REFERENCES VOYAGES (
            VOYAGEID
        );

ALTER TABLE VOYAGEMOYENTRANSPORT
    ADD CONSTRAINT FK_VMTRANS_M FOREIGN KEY (
        MOYENID
    )
        REFERENCES MOYENTRANSPORT (
            MOYENID
        );

--====================== INDEX =====================--
/*--Email index

CREATE INDEX idx_clients_email
ON clients(Email)
TABLESPACE ts_index_agence;
*/

--Reservations index cles etrangeres

CREATE INDEX IDX_RESERVATIONS_CLIENTID
ON RESERVATIONS(CLIENTID)
TABLESPACE TS_INDEX_AGENCE;

CREATE INDEX IDX_RESERVATIONS_VOYAGEID
ON RESERVATIONS(VOYAGEID)
TABLESPACE TS_INDEX_AGENCE;

CREATE INDEX IDX_RESERVATIONS_SURCUSSALID
ON RESERVATIONS(SURCUSSALID)
TABLESPACE TS_INDEX_AGENCE;

CREATE INDEX IDX_RESERVATIONS_AGENTID
ON RESERVATIONS(AGENTID)
TABLESPACE TS_INDEX_AGENCE;

--TRIGGERS

--1. Validation de l'âge minimum des clients :
-- Un trigger pour vérifier que l'âge d'un client est d'au moins 18 ans lors de l'insertion ou de la mise à jour de sa date de naissance.


CREATE OR REPLACE TRIGGER TRG_VALIDATE_AGE BEFORE
    INSERT OR UPDATE ON CLIENTS FOR EACH ROW
BEGIN
    IF (MONTHS_BETWEEN(SYSDATE, :NEW.DATENAISSANCE) / 12) < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le client doit avoir au moins 18 ans.');
    END IF;
END;
/

-- 2. Mise à jour automatique de la date de retour :
-- Un trigger pour s'assurer que la date de retour est après la date de départ pour les enregistrements dans la table Voyages.


CREATE OR REPLACE TRIGGER TRG_VALIDATE_DATES BEFORE
    INSERT OR UPDATE ON VOYAGES FOR EACH ROW
BEGIN
    IF :NEW.DATERETOUR <= :NEW.DATEDEPART THEN
        RAISE_APPLICATION_ERROR(-20002, 'La date de retour doit être après la date de départ.');
    END IF;
END;
/

-- 3.Log des modifications de réservations :
-- Un trigger pour enregistrer les modifications apportées aux réservations dans une table de log.


CREATE TABLE RESERVATIONLOGS (
    LOGID INT PRIMARY KEY,
    RESERVATIONID NUMBER,
    ACTION VARCHAR2(50),
    DATEACTION DATE,
    DESCRIPTION VARCHAR2(255)
);

-- just in case...
--DROP SEQUENCE ReservationLogs_seq;

CREATE SEQUENCE RESERVATIONLOGS_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_LOG_RESERVATION_CHANGES AFTER
    INSERT OR UPDATE OR DELETE ON RESERVATIONS FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO RESERVATIONLOGS (
            LOGID,
            RESERVATIONID,
            ACTION,
            DATEACTION,
            DESCRIPTION
        ) VALUES (
            RESERVATIONLOGS_SEQ.NEXTVAL,
            :NEW.RESERVATIONID,
            'INSERT',
            SYSDATE,
            'Nouvelle réservation ID: '
            || :NEW.RESERVATIONID
        );
    ELSIF UPDATING THEN
        INSERT INTO RESERVATIONLOGS (
            LOGID,
            RESERVATIONID,
            ACTION,
            DATEACTION,
            DESCRIPTION
        ) VALUES (
            RESERVATIONLOGS_SEQ.NEXTVAL,
            :OLD.RESERVATIONID,
            'UPDATE',
            SYSDATE,
            'Modification sur la réservation ID: '
            || :OLD.RESERVATIONID
        );
    ELSIF DELETING THEN
        INSERT INTO RESERVATIONLOGS (
            LOGID,
            RESERVATIONID,
            ACTION,
            DATEACTION,
            DESCRIPTION
        ) VALUES (
            RESERVATIONLOGS_SEQ.NEXTVAL,
            :OLD.RESERVATIONID,
            'DELETE',
            SYSDATE,
            'Suppression de la réservation ID: '
            || :OLD.RESERVATIONID
        );
    END IF;
END;
/

-- 4. Vérification du format de l'email :
-- Un trigger pour vérifier que le format de l'email est correct lors de l'insertion ou de la mise à jour dans les tables Clients, Agence, et Agents.

CREATE OR REPLACE TRIGGER TRG_VALIDATE_EMAIL_CLIENTS BEFORE
    INSERT OR UPDATE ON CLIENTS FOR EACH ROW
BEGIN
    IF INSTR(:NEW.EMAIL, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Email invalide.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_VALIDATE_EMAIL_AGENCE BEFORE
    INSERT OR UPDATE ON AGENCE FOR EACH ROW
BEGIN
    IF INSTR(:NEW.EMAIL, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Email invalide.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_VALIDATE_EMAIL_AGENTS BEFORE
    INSERT OR UPDATE ON AGENTS FOR EACH ROW
BEGIN
    IF INSTR(:NEW.EMAIL, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Email invalide.');
    END IF;
END;
/

-- 5. Vérification des Paiements
-- Un trigger qui vérifie le mode de paiement :
-- Vérifier le mode de paiement lors de l'insertion ou de la mise à jour

CREATE OR REPLACE TRIGGER TRG_CHECK_MODE_PAIEMENT BEFORE
    INSERT OR UPDATE ON PAIEMENTS FOR EACH ROW
BEGIN
    IF :NEW.MODEPAIEMENT NOT IN ('paypal', 'cash', 'visa') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Mode de paiement invalide.');
    END IF;
END;
/

-- 6. Mise à jour du MontantTotal dans les réservations
-- Ce trigger vérifie si le voyage est un aller-retour. Si oui, il double le montant de la réservation.
-- Sinon, il garde le montant initial basé sur le prix du moyen de transport associé.

CREATE OR REPLACE TRIGGER TRG_UPDATE_MONTANT BEFORE
    INSERT OR UPDATE ON RESERVATIONS FOR EACH ROW
DECLARE
    MONTANT NUMBER;
BEGIN
    IF :NEW.ALLERRETOUR = 1 THEN
        SELECT
            VMT.PRIX * 2 INTO MONTANT
        FROM
            VOYAGEMOYENTRANSPORT VMT
            JOIN VOYAGES V
            ON VMT.VOYAGEID = V.VOYAGEID
        WHERE
            VMT.VOYAGEID = V.VOYAGEID
            AND VMT.VOYAGEID = :NEW.VOYAGEID;
    ELSE
        SELECT
            VMT.PRIX INTO MONTANT
        FROM
            VOYAGEMOYENTRANSPORT VMT
            JOIN VOYAGES V
            ON VMT.VOYAGEID = V.VOYAGEID
        WHERE
            VMT.VOYAGEID = V.VOYAGEID
            AND VMT.VOYAGEID = :NEW.VOYAGEID;
    END IF;

    :NEW.MONTANTTOTAL := MONTANT;
END;
/

--============================== Part Insertion ===============================
-- Insérer pour l’instant en moyenne une dizaine de lignes de test dans chacune des
-- tables.
/*DELETE FROM paiements;
DELETE FROM reservations;
DELETE FROM voyageMoyentransport;
DELETE FROM agents;
DELETE FROM voyages;
DELETE FROM moyenTransport;
DELETE FROM originesDestinations;
DELETE FROM agence;
DELETE FROM clients; */

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    1,
    'Coquillon',
    'Paul',
    TO_DATE('1999-10-27', 'YYYY-MM-DD'),
    'pauldenisc@gmail.com',
    '47404640',
    '5, catalpa 9 Delmas 75'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    2,
    'Cadet',
    'Boaz',
    TO_DATE('2000-06-18', 'YYYY-MM-DD'),
    'cadet.boaz@gmail.com',
    '31493145',
    '6, Cassagnol 17 Delmas 75'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    3,
    'Lefebvre',
    'Paul',
    TO_DATE('1985-07-30', 'YYYY-MM-DD'),
    'paul.lefebvre@yahoo.fr',
    '0019254123541',
    '789 Rue James NY'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    4,
    'Moreau',
    'Sophie',
    TO_DATE('1992-11-05', 'YYYY-MM-DD'),
    'sophie.moreau@gmail.com',
    '35241542',
    '101 Ruelle chavanne P-au-P'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    5,
    'Theork',
    'Casimir',
    TO_DATE('1996-07-26', 'YYYY-MM-DD'),
    'casimirt56@gmail.com',
    '49075027',
    '23, Christ-Roi P-au-P'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    6,
    'Jean',
    'Marc',
    TO_DATE('1975-06-18', 'YYYY-MM-DD'),
    'marc.jean@gmail.com',
    '0135792468',
    '303 Rue du Commerce'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    7,
    'Rousseau',
    'Julie',
    TO_DATE('1995-12-25', 'YYYY-MM-DD'),
    'julie.rousseau@yahoo.fr',
    '554599052520',
    '404 Avenue des Étoiles Brazil'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    8,
    'Joseph',
    'Emma',
    TO_DATE('1983-08-10', 'YYYY-MM-DD'),
    'emma.joseph12@gmail.com',
    '37421245',
    '505 Boulevard Dessalines'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    9,
    'Gabriel',
    'Mopolo',
    TO_DATE('1955-04-22', 'YYYY-MM-DD'),
    'gabriel.mopolo@gmail.com',
    '0033673212284',
    '1645 route des Lucioles, Sophia Antipolis, 06410 Biot'
);

INSERT INTO CLIENTS (
    CLIENTID,
    NOM,
    PRENOM,
    DATENAISSANCE,
    EMAIL,
    TELEPHONE,
    ADRESSE
) VALUES (
    10,
    'Bertrand',
    'Edline',
    TO_DATE('1982-09-11', 'YYYY-MM-DD'),
    'louis.bertrand@gmail.com',
    '42021212',
    '23, rue manguier joseph Guilloux'
);

--========================
INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    1,
    'Agence Petion-Ville',
    '12 Rue de la Gare Petion-Ville',
    '42154748',
    'agency.1.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    2,
    'Agence Jacmel',
    '34 Boulevard Monchil',
    '36451201',
    'agency.2.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    3,
    'Agence Miami',
    '56 kingstreet miami florida',
    '10498347651',
    'agency.3.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    4,
    'Agence Delmas',
    '8, rue jeremie Delmas 25',
    '34124547',
    'agency.4.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    5,
    'Agence Cayes',
    'rue 4 chemins Cayes Haiti',
    '22454745',
    'agency.5.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    6,
    'Agence Cap-Haitien',
    'rue L Cap-Haitien',
    '44457845',
    'agency.6.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    7,
    'Agence Port-de-Paix',
    '34 Avenue Jean Médecin',
    '36251412',
    'agency.7.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    8,
    'Agence France',
    '56 Boulevard Vincent Gâche',
    '0245789234',
    'agency.8.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    9,
    'Agence New-Jersey',
    '1289 Broadway, Apt. 512 New Jersey, NJ 1006 USA',
    '0389456712',
    'agency.9.inuka@inukaagency.com'
);

INSERT INTO AGENCE (
    SURCUSSALID,
    NOMSURCUSSAL,
    ADRESSE,
    TELEPHONE,
    EMAIL
) VALUES (
    10,
    'Agence New-York',
    '1234 Broadway, Apt. 567 New York, NY 10001 USA',
    '2125551234',
    'agency.10.inuka@inukaagency.com'
);

--=================

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    1,
    'Haiti',
    'P-au-P'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    2,
    'USA',
    'New York'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    3,
    'USA',
    'Fort-Lauderdale'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    4,
    'Haiti',
    'Port-de-Paix'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    5,
    'Haiti',
    'Belle-Ans'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    6,
    'France',
    'Lyon'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    7,
    'Haiti',
    'Cayes'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    8,
    'Haiti',
    'Jacmel'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    9,
    'USA',
    'San Francisco'
);

INSERT INTO ORIGINESDESTINATIONS (
    ORIGINEDESTINATIONID,
    PAYS,
    VILLE
) VALUES (
    10,
    'France',
    'Paris'
);

--=====================

INSERT INTO MOYENTRANSPORT (
    MOYENID,
    TYPE
) VALUES (
    1,
    'Bus'
);

INSERT INTO MOYENTRANSPORT (
    MOYENID,
    TYPE
) VALUES (
    2,
    'Avion'
);

INSERT INTO MOYENTRANSPORT (
    MOYENID,
    TYPE
) VALUES (
    3,
    'Jet Prive'
);

INSERT INTO MOYENTRANSPORT (
    MOYENID,
    TYPE
) VALUES (
    4,
    'Taxi'
);

--=======================

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    1,
    1,
    3,
    2,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'),
    TO_DATE('2024-01-20', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    2,
    2,
    1,
    2,
    TO_DATE('2024-02-15', 'YYYY-MM-DD'),
    TO_DATE('2024-02-25', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    3,
    3,
    9,
    2,
    TO_DATE('2024-03-01', 'YYYY-MM-DD'),
    TO_DATE('2024-04-15', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    4,
    4,
    5,
    1,
    TO_DATE('2024-04-05', 'YYYY-MM-DD'),
    TO_DATE('2024-04-20', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    5,
    5,
    8,
    1,
    TO_DATE('2024-05-10', 'YYYY-MM-DD'),
    TO_DATE('2024-05-20', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    6,
    6,
    10,
    3,
    TO_DATE('2024-06-15', 'YYYY-MM-DD'),
    TO_DATE('2024-06-25', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    7,
    7,
    8,
    4,
    TO_DATE('2024-07-01', 'YYYY-MM-DD'),
    TO_DATE('2024-07-10', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    8,
    8,
    4,
    1,
    TO_DATE('2024-08-05', 'YYYY-MM-DD'),
    TO_DATE('2024-08-15', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    9,
    9,
    10,
    2,
    TO_DATE('2023-09-10', 'YYYY-MM-DD'),
    TO_DATE('2023-09-20', 'YYYY-MM-DD')
);

INSERT INTO VOYAGES (
    VOYAGEID,
    ORIGINEID,
    DESTINATIONID,
    MOYENID,
    DATEDEPART,
    DATERETOUR
) VALUES (
    10,
    10,
    1,
    2,
    TO_DATE('2023-10-05', 'YYYY-MM-DD'),
    TO_DATE('2023-10-15', 'YYYY-MM-DD')
);

--======================

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    1,
    1,
    'Durand',
    'Alice',
    'alice.durand@inukaagency.com',
    '2214-3214'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    2,
    2,
    'Leblanc',
    'Pierre',
    'pierre.leblanc@inukaagency.com',
    '2828-5020'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    3,
    3,
    'Garnier',
    'Marie',
    'marie.garnier@inukaagency.com',
    '2424-3012'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    4,
    4,
    'Lopez',
    'Jean',
    'jean.lopez@inukaagency.com',
    '2214-5412'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    5,
    5,
    'Carpentier',
    'Sophie',
    'sophie.carpentier@inukaagency.com',
    '2828-4514'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    6,
    6,
    'Benoit',
    'Luc',
    'luc.benoit@inukaagency.com',
    '2232-1547'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    7,
    7,
    'Lemoine',
    'Claire',
    'claire.lemoine@inukaagency.com',
    '2828-2245'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    8,
    8,
    'Leroy',
    'Marc',
    'marc.leroy@inukaagency.com',
    '2822-2845'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    9,
    9,
    'Dufresne',
    'Julie',
    'julie.dufresne@inukaagency.com',
    '2245-4215'
);

INSERT INTO AGENTS (
    AGENTID,
    SURCUSSALID,
    NOM,
    PRENOM,
    EMAIL,
    TELEPHONE
) VALUES (
    10,
    10,
    'Blanc',
    'François',
    'francois.blanc@inukaagency.com',
    '2541-5232'
);

--===================

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    1,
    2,
    600
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    2,
    3,
    2000
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    3,
    2,
    300
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    4,
    1,
    80
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    5,
    4,
    40
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    6,
    2,
    100
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    7,
    4,
    30
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    8,
    1,
    70
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    9,
    2,
    1300
);

INSERT INTO VOYAGEMOYENTRANSPORT (
    VOYAGEID,
    MOYENID,
    PRIX
) VALUES (
    10,
    2,
    1500
);

--=====================

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    1,
    1,
    1,
    1,
    1,
    TO_DATE('2023-12-01', 'YYYY-MM-DD'),
    0,
    1
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    2,
    2,
    2,
    2,
    2,
    TO_DATE('2023-12-15', 'YYYY-MM-DD'),
    0,
    0
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    3,
    3,
    3,
    3,
    3,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'),
    0,
    1
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    4,
    4,
    4,
    4,
    4,
    TO_DATE('2024-01-20', 'YYYY-MM-DD'),
    0,
    0
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    5,
    5,
    5,
    5,
    5,
    TO_DATE('2024-02-05', 'YYYY-MM-DD'),
    0,
    1
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    6,
    6,
    6,
    6,
    6,
    TO_DATE('2024-02-15', 'YYYY-MM-DD'),
    0,
    1
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    7,
    7,
    7,
    7,
    7,
    TO_DATE('2024-03-01', 'YYYY-MM-DD'),
    0,
    1
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    8,
    8,
    8,
    8,
    8,
    TO_DATE('2024-03-15', 'YYYY-MM-DD'),
    0,
    0
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    9,
    9,
    9,
    9,
    9,
    TO_DATE('2024-04-01', 'YYYY-MM-DD'),
    0,
    0
);

INSERT INTO RESERVATIONS (
    RESERVATIONID,
    CLIENTID,
    VOYAGEID,
    SURCUSSALID,
    AGENTID,
    DATERESERVATION,
    MONTANTTOTAL,
    ALLERRETOUR
) VALUES (
    10,
    10,
    10,
    10,
    10,
    TO_DATE('2024-04-15', 'YYYY-MM-DD'),
    0,
    1
);

--====================

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    1,
    1,
    'visa'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    2,
    2,
    'paypal'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    3,
    3,
    'cash'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    4,
    4,
    'visa'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    5,
    5,
    'paypal'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    6,
    6,
    'cash'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    7,
    7,
    'visa'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    8,
    8,
    'paypal'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    9,
    9,
    'cash'
);

INSERT INTO PAIEMENTS (
    PAIEMENTID,
    RESERVATIONID,
    MODEPAIEMENT
) VALUES (
    10,
    10,
    'visa'
);

--=====================

-- 3. Étape d'Administration (2 jours)

--Ecrire un script (fichier de contrôle SQLLOADER) qui permet de charger les lignes contenues
--dans un fichier CSV (ligne à construire dans EXCEL) vers une ou plusieurs de vos tables. Les
--données sont à préparer auparavant.

-- Fichier 'load_clients.ctl'

LOAD DATA INFILE 'C:\Users\Denis\Desktop\ProjetOracle\load_clients.csv'
INTO TABLE CLIENTS

APPEND

FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS

( CLIENTID INTEGER EXTERNAL,
NOM CHAR(255),
PRENOM CHAR(255),
DATENAISSANCE DATE "YYYY-MM-DD",
EMAIL CHAR(255),
TELEPHONE CHAR(20),
ADRESSE CHAR(255) )
 -- bash command in CMD
SQLLDR AGENCEUSER/PAUL@XE CONTROL=LOAD_CLIENTS.CTL LOG=LOAD_CLIENTS.LOG
 -- 3.2 3.2 Divers requêtes
-- 1) Ecrire une requête SQL qui permet de visualiser l’ensemble des fichiers qui composent votre base <réponses et trace ici>
SELECT
    *
FROM
    DBA_DATA_FILES;

-- 2) Ecrire une requête SQL qui permet de lister en une requête l’ensembles des tablespaces avec leur fichiers. La taille de chaque fichier doit apparaître, le volume total de l’espace occupé par fichier ainsi que le volume total de l’espace libre par fichier

SELECT
    T.TABLESPACE_NAME,
    DF.FILE_NAME,
    DF.BYTES / 1024 / 1024 AS TAILLE_FICHIER_MO,
    SUM(DFS.BYTES) / 1024 / 1024 AS ESPACE_OCCUPE_MO,
    (DF.BYTES - SUM(DFS.BYTES)) / 1024 / 1024 AS ESPACE_LIBRE_MO
FROM
    DBA_DATA_FILES  DF
    JOIN DBA_TABLESPACES T
    ON DF.TABLESPACE_NAME = T.TABLESPACE_NAME
    LEFT JOIN DBA_FREE_SPACE DFS
    ON DF.FILE_ID = DFS.FILE_ID
GROUP BY
    T.TABLESPACE_NAME,
    DF.FILE_NAME,
    DF.BYTES
ORDER BY
    T.TABLESPACE_NAME,
    DF.FILE_NAME;

-- 3) Ecrire une requête SQL qui permet de lister les segments et leurs extensions de chacun des segments (tables ou indexes) de votre utilisateur <réponses et trace ici>

SELECT
    OWNER,
    SEGMENT_NAME,
    SEGMENT_TYPE,
    TABLESPACE_NAME,
    BYTES / 1024 / 1024 AS SEGMENT_SIZE_MB,
    EXTENTS,
    INITIAL_EXTENT / 1024 / 1024 AS INITIAL_EXTENT_MB,
    NEXT_EXTENT / 1024 / 1024 AS NEXT_EXTENT_MB
FROM
    DBA_SEGMENTS
WHERE
    OWNER = 'AGENCEUSER'
 -- 4) Ecrire une requête qui permet pour chacun de vos segments de donner le nombre total de blocs du segment, le nombre  de blocs utilisés et le nombre de blocs libres
    SELECT
        S.SEGMENT_NAME,
        S.SEGMENT_TYPE,
        S.TABLESPACE_NAME,
        NVL(F.TOTAL_BLOCKS, 0)              AS TOTAL_BLOCKS,
        (NVL(F.TOTAL_BLOCKS, 0) - S.BLOCKS) AS USED_BLOCKS,
        S.BLOCKS                            AS FREE_BLOCKS
    FROM
        DBA_SEGMENTS S
        LEFT JOIN (
            SELECT
                TABLESPACE_NAME,
                SEGMENT_NAME,
                SUM(BLOCKS)     AS TOTAL_BLOCKS
            FROM
                DBA_EXTENTS
            GROUP BY
                TABLESPACE_NAME,
                SEGMENT_NAME
        ) F
        ON S.SEGMENT_NAME = F.SEGMENT_NAME
        AND S.TABLESPACE_NAME = F.TABLESPACE_NAME
    WHERE
        S.OWNER = 'AGENCEUSER'
    ORDER BY
        S.SEGMENT_NAME;

-- 5) Ecrire une requête SQL qui permet de compacter et réduire un segment

-- Activer le mouvement des lignes

ALTER TABLE VOYAGES ENABLE ROW MOVEMENT;

-- Compacter et réduire le segment voyages

ALTER TABLE VOYAGES SHRINK SPACE;

-- 6) Ecrire une requête qui permet d’afficher l’ensemble des utilisateurs de votre base et leurs droits

SELECT
    U.USERNAME,
    RP.GRANTED_ROLE
FROM
    DBA_USERS      U
    JOIN DBA_ROLE_PRIVS RP
    ON U.USERNAME = RP.GRANTEE
ORDER BY
    U.USERNAME;

-- 7)  Proposer trois requêtes libres au choix de recherche d’objets dans le dictionnaire Oracle


-- a) Afficher les noms de toutes les tables de AGENCEUSER

SELECT
    TABLE_NAME,
    OWNER
FROM
    ALL_TABLES
WHERE
    OWNER = 'AGENCEUSER';

-- b) lister tous les index de la table RESERVATIONS appartenant à l’utilisateur AGENCEUSER, en fournissant des détails sur le nom de l’index, son type, les colonnes associées et si l’index est unique ou non.

SELECT
    I.INDEX_NAME,
    I.INDEX_TYPE,
    IC.COLUMN_NAME,
    I.UNIQUENESS
FROM
    ALL_INDEXES     I
    JOIN ALL_IND_COLUMNS IC
    ON I.INDEX_NAME = IC.INDEX_NAME
WHERE
    I.TABLE_NAME = 'RESERVATIONS'
    AND I.TABLE_OWNER = 'AGENCEUSER'
ORDER BY
    I.INDEX_NAME,
    IC.COLUMN_POSITION;

-- c) lister tous les triggers disponibles dans la base de données, en fournissant des détails sur leur nom, table associée et statut de AGENCEUSER.
SELECT
    TRIGGER_NAME,
    OWNER,
    TABLE_NAME,
    STATUS
FROM
    ALL_TRIGGERS
WHERE
    OWNER = 'AGENCEUSER'
ORDER BY
    OWNER,
    TRIGGER_NAME;

--=============================================Sauvegarde=============================================---

-- 3.3 Mise en place d'une stratégie de sauvegarde et restauration
-- (voir le chap. 6 du cours ADB1)

-- Connecter en tant que SYSDBA
CONNECT AS SYSDBA agenceuser/password;

GRANT SYSDBA TO AGENCEUSER;

-- Arrêter la base de données
SHUTDOWN IMMEDIATE;

-- Démarrer la base de données en mode montage
STARTUP MOUNT;

-- Start RMAN in CMD
RMAN TARGET

/

-- Sauvegarder les fichiers de données
BACKUP DATABASE;

-- Sauvegarder les fichiers d'archives
BACKUP ARCHIVELOG ALL;

-- Sauvegarder le SPFILE
BACKUP SPFILE;

-- Sauvegarder les fichiers de contrôle
BACKUP CURRENT CONTROLFILE;

-- Ouvrir la base de données
ALTER DATABASE OPEN;

-- 3.4 Provoquer deux pannes au moins

-- 1    La perte de fichiers de données
--    suppression du du tablespace 'TS_TABLE_AGENCE.dbf'
DROP TABLESPACE TS_TABLE_AGENCE INCLUDING CONTENTS AND DATAFILES;

-- y remedier

RMAN> RMAN TARGET /
RMAN> SHUTDOWN IMMEDIATE;

RMAN> STARTUP MOUNT;

RMAN> REPORT SCHEMA;

LISTE DES FICHIERS DE DONNÚES PERMANENTS
===========================
FILE SIZE(MB) TABLESPACE RB SEGS DATAFILE NAME

---- -------- -------------------- ------- ------------------------
1 920 SYSTEM *** C:\ORACLE19C\ORADATA\ORCL\SYSTEM01.DBF

2 5 TS_INDEX_AGENCE *** C:\ORACLE\ORACLE\ORADATA\TS_INDEX_AGENCE.DBF

3 1080 SYSAUX *** C:\ORACLE19C\ORADATA\ORCL\SYSAUX01.DBF

4 65 UNDOTBS1 *** C:\ORACLE19C\ORADATA\ORCL\UNDOTBS01.DBF

5 0 TS_TABLE_AGENCE *** C:\ORACLE\ORACLE\ORADATA\TS_TABLE_AGENCE.DBF

7 7 USERS *** C:\ORACLE19C\ORADATA\ORCL\USERS01.DBF

LISTE DES FICHIERS TEMPORAIRES
=======================
FILE SIZE(MB) TABLESPACE MAXSIZE(MB) TEMPFILE NAME

---- -------- -------------------- ----------- --------------------
1 135 TEMP 32767 C:\ORACLE19C\ORADATA\ORCL\TEMP01.DBF

RMAN> RESTORE DATAFILE 5;

RMAN> RESTORE DATABASE;

RMAN> RECOVER DATABASE;

RMAN> ALTER DATABASE OPEN RESETLOGS;

RMAN> EXIT

C:\oracle\oracle\oradata>sqlplus agenceuser/password

SQL*PLUS: RELEASE 19.0.0.0.0 - PRODUCTION ON SAM. AO¹T 10 18:32:37 2024
VERSION 19.3.0.0.0
COPYRIGHT (C) 1982, 2019, ORACLE. ALL RIGHTS RESERVED.
HEURE DE LA DERNIÞRE CONNEXION RÚUSSIE : SAM. AO¹T 10 2024 16:17:52 -04:00
CONNECTÚ Ó :
ORACLE DATABASE 19c ENTERPRISE EDITION RELEASE 19.0.0.0.0 - PRODUCTION
VERSION 19.3.0.0.0
SQL> SELECT NOM

2 FROM (

3 SELECT nom

4 FROM clients

5 )

6 WHERE ROWNUM <= 5;

NOM

--------------------------------------------------------------------------------
COQUILLON
CADET
LEFEBVRE
MOREAU
THEORK

-- 2    La perte de fichiers de contrôles.

C:\oracle\oracle\oradata> del C:\ORACLE19C\ORADATA\ORCL\CONTROL01.CTL

SQL> SELECT NAME FROM V$CONTROLFILE;

NAME

--------------------------------------------------------------------------------
C:\ORACLE19C\ORADATA\ORCL\CONTROL01.CTL

C:\ORACLE19C\ORADATA\ORCL\CONTROL02.CTL

SQL> CONNECT AS SYSDBA;

ENTREZ LE NOM UTILISATEUR : SYS
ENTREZ LE MOT DE PASSE :
CONNECTÚ.
SQL> SHUTDOWN IMMEDIATE;

ORA-00210: OUVERTURE IMPOSSIBLE DU FICHIER DE CONTR¶LE INDIQUÚ
ORA-00202: FICHIER DE CONTR¶LE : 'C:\ORACLE19C\ORADATA\ORCL\CONTROL01.CTL'
ORA-27041: OUVERTURE DU FICHIER IMPOSSIBLE
OSD-04002: OUVERTURE IMPOSSIBLE DU FICHIER
O/S-ERROR: (OS 2) LE FICHIER SP+FI+ST INTROUVABLE.
SQL> SELECT NAME FROM V$CONTROLFILE;

NAME

--------------------------------------------------------------------------------
C:\ORACLE19C\ORADATA\ORCL\CONTROL01.CTL

C:\ORACLE19C\ORADATA\ORCL\CONTROL02.CTL

-- y remedier

SQL> SHUTDOWN ABORT;

INSTANCE ORACLE ARRÛTÚE.
SQL> STARTUP NOMOUNT;

INSTANCE ORACLE LANCÚE.
SQL> EXIT

C:\oracle\oracle\oradata>rman target

/

RMAN> RESTORE CONTROLFILE FROM 'C:\ORACLE\ORACLE\DATABASE\C-1685328412-20240810-05';

RMAN> ALTER DATABASE MOUNT;

RMAN> RESTORE DATABASE;

RMAN> RECOVER DATABASE;

RMAN> ALTER DATABASE OPEN RESETLOGS;

-- 3.5 Export / import
-- ========================== EXPORT IMPORT ==========================

--Exporter les données de l’utilisateur

-- Créez un répertoire pour stocker le fichier d’exportation :
CREATE DIRECTORY EXPORTATION AS 'path\to\';

-- Attribuez les privilèges nécessaires :
GRANT READ, WRITE ON DIRECTORY EXPORTATION TO AGENCEUSER;

--Exécutez la commande expdp pour exporter les données (CMD)

EXPDP AGENCEUSER/PASSWORD DIRECTORY=EXPORTATION DUMPFILE=AGENCEUSER.DMP SCHEMAS=AGENCEUSER

-- Importer les données dans la nouvelle base

--Créez un répertoire pour stocker le fichier d’importation
CREATE DIRECTORY IMPORTATION AS 'path\to\import';

--Créez un répertoire pour stocker le fichier d’importation
GRANT READ, WRITE ON DIRECTORY IMPORTATION TO AGENCEUSER;

--Exécutez la commande impdp pour importer les données (CMD)
IMPDP AGENCEUSER/PASSWORD DIRECTORY=IMPORTATION DUMPFILE=AGENCEUSER.DMP SCHEMAS=AGENCEUSER