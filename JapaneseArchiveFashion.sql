-- ==========================================
-- ПОДГОТОВКА БАЗЫ ДАННЫХ
-- ==========================================
USE master;
GO

IF DB_ID('JapaneseArchiveFashion') IS NOT NULL
BEGIN
    ALTER DATABASE JapaneseArchiveFashion SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE JapaneseArchiveFashion;
END
GO

CREATE DATABASE JapaneseArchiveFashion;
GO

ALTER DATABASE JapaneseArchiveFashion SET COMPATIBILITY_LEVEL = 160;
GO

USE JapaneseArchiveFashion;
GO


-- ==========================================
-- ПУНКТ 1. СОЗДАНИЕ ТАБЛИЦ УЗЛОВ
-- ==========================================

CREATE TABLE Brands (
    BrandID      INT PRIMARY KEY,
    BrandName    NVARCHAR(100) NOT NULL,
    FoundedYear  INT,
    Country      NVARCHAR(50),
    Description  NVARCHAR(500)
) AS NODE;
GO

CREATE TABLE Designers (
    DesignerID   INT PRIMARY KEY,
    FullName     NVARCHAR(100) NOT NULL,
    BirthYear    INT,
    Nationality  NVARCHAR(50)
) AS NODE;
GO

CREATE TABLE Collections (
    CollectionID    INT PRIMARY KEY,
    CollectionName  NVARCHAR(200) NOT NULL,
    Season          NVARCHAR(20),      -- 'SS' / 'FW'
    Year            INT
) AS NODE;
GO

CREATE TABLE Cities (
    CityID      INT PRIMARY KEY,
    CityName    NVARCHAR(100) NOT NULL,
    Country     NVARCHAR(50),
    Population  INT
) AS NODE;
GO


-- ==========================================
-- ПУНКТ 2. ТАБЛИЦЫ РЁБЕР
-- ==========================================

CREATE TABLE WorksFor (
    StartYear INT,
    EndYear   INT NULL,
    Role      NVARCHAR(100),
    CONSTRAINT EC_WorksFor CONNECTION (Designers TO Brands)
) AS EDGE;
GO

-- бренд выпустил коллекцию
CREATE TABLE Released (
    ReleaseDate   DATE,
    NumberOfLooks INT,
    IsArchived    BIT,
    CONSTRAINT EC_Released CONNECTION (Brands TO Collections)
) AS EDGE;
GO

-- бренд базируется в городе
CREATE TABLE BasedIn (
    SinceYear     INT,
    IsHeadquarter BIT,
    CONSTRAINT EC_BasedIn CONNECTION (Brands TO Cities)
) AS EDGE;
GO

-- направленная связь "вдохновился"
CREATE TABLE InspiredBy (
    InspirationYear INT,
    InfluenceLevel  INT,                 -- 1..10
    [Description]   NVARCHAR(300),
    CONSTRAINT EC_InspiredBy CONNECTION (Brands TO Brands)
) AS EDGE;
GO

CREATE TABLE Mentored (
    StartYear  INT,
    YearsCount INT,
    CONSTRAINT EC_Mentored CONNECTION (Designers TO Designers)
) AS EDGE;
GO


-- ==========================================
-- ПУНКТ 3. ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ
-- ==========================================

INSERT INTO Brands (BrandID, BrandName, FoundedYear, Country, [Description]) VALUES
(1,  N'Number (N)ine',      1996, N'Япония', N'Бренд Такахиро Миясита, гранж-эстетика, рок-н-ролл-силуэты'),
(2,  N'Tornado Mart',       1991, N'Япония', N'Глэм-рок и готик-эстетика, токийская сцена 90-х'),
(3,  N'Undercover',         1990, N'Япония', N'Авангардный бренд Джуна Такахаси, панк и концептуализм'),
(4,  N'20471120',           1994, N'Япония', N'Экспериментальный бренд Маруяма/Фукуда, рейв-эстетика'),
(5,  N'Comme des Garçons',  1969, N'Япония', N'Авангард Рэй Кавакубо, деконструкция и анти-мода'),
(6,  N'Yohji Yamamoto',     1981, N'Япония', N'Деконструктивизм, чёрная палитра, японская поэтика'),
(7,  N'Issey Miyake',       1970, N'Япония', N'Технологичная мода, плиссировка, A-POC'),
(8,  N'Junya Watanabe',     1992, N'Япония', N'Концептуальный бренд под эгидой CDG'),
(9,  N'Sacai',              1999, N'Япония', N'Гибридные конструкции Читосэ Абэ'),
(10, N'Visvim',             2000, N'Япония', N'Японский крафт + американский heritage'),
(11, N'Neighborhood',       1994, N'Япония', N'Байкер- и милитари-эстетика, Урахарадзюку'),
(12, N'A Bathing Ape',      1993, N'Япония', N'Культовый стритвир Ниго'),
(13, N'Goodenough',         1990, N'Япония', N'Первый тру-стритвир бренд Японии, истоки Урахарадзюку'),
(14, N'WTAPS',              1996, N'Япония', N'Милитари-стритвир, философия "Placing things where they should be"'),
(15, N'Hysteric Glamour',   1984, N'Япония', N'Американский поп-арт, порно-шик и рок-н-ролл 60-х'),
(16, N'Mastermind Japan',   1997, N'Япония', N'Люксовый панк, черепа, премиальные ткани и ручная работа'),
(17, N'Julius',             2001, N'Япония', N'Индустриальная готика, киберпанк, тотальный чёрный цвет');

INSERT INTO Designers (DesignerID, FullName, BirthYear, Nationality) VALUES
(1,  N'Такахиро Миясита',  1973, N'Японец'),
(2,  N'Кодзи Ёсидa',       1965, N'Японец'),
(3,  N'Джун Такахаси',     1969, N'Японец'),
(4,  N'Масахико Маруяма',  1967, N'Японец'),
(5,  N'Лика Фукуда',       1968, N'Японка'),
(6,  N'Рэй Кавакубо',      1942, N'Японка'),
(7,  N'Йоджи Ямамото',     1943, N'Японец'),
(8,  N'Иссэй Миякэ',       1938, N'Японец'),
(9,  N'Джунья Ватанабэ',   1961, N'Японец'),
(10, N'Читосэ Абэ',        1965, N'Японка'),
(11, N'Хироки Накамура',   1971, N'Японец'),
(12, N'Синсукэ Такидзава', 1969, N'Японец'),
(13, N'Хироси Фудзивара',  1964, N'Японец'),
(14, N'Тэцу Нисияма',      1974, N'Японец'),
(15, N'Нобухико Китамура', 1962, N'Японец'),
(16, N'Масааки Хомма',     1970, N'Японец'),
(17, N'Тацуро Хорикава',   1968, N'Японец');

INSERT INTO Collections (CollectionID, CollectionName, Season, [Year]) VALUES
(1,  N'Touch Me I''m Sick',      N'FW', 2002),
(2,  N'Welcome to the Shadow',   N'SS', 2004),
(3,  N'Scab',                    N'SS', 2003),
(4,  N'Languid',                 N'SS', 2004),
(5,  N'But Beautiful',           N'FW', 2004),
(6,  N'Hyper Olympic',           N'SS', 1997),
(7,  N'Lumps and Bumps',         N'SS', 1997),
(8,  N'First Paris Collection',  N'FW', 1981),
(9,  N'Pleats Please',           N'SS', 1993),
(10, N'Techno Couture',          N'SS', 2000),
(11, N'Hybrid Collection',       N'FW', 2010),
(12, N'FBT Release',             N'SS', 2001);

INSERT INTO Cities (CityID, CityName, Country, Population) VALUES
(1,  N'Токио',    N'Япония',         13960000),
(2,  N'Париж',    N'Франция',        2161000),
(3,  N'Осака',    N'Япония',         2691000),
(4,  N'Киото',    N'Япония',         1463000),
(5,  N'Нью-Йорк', N'США',            8336000),
(6,  N'Лондон',   N'Великобритания', 8982000),
(7,  N'Милан',    N'Италия',         1352000),
(8,  N'Гонконг',  N'Китай',          7500000),
(9,  N'Сеул',     N'Южная Корея',    9776000),
(10, N'Йокогама', N'Япония',         3760000);
GO


-- ==========================================
-- ПУНКТ 4. ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР
-- ==========================================

INSERT INTO WorksFor ($from_id, $to_id, StartYear, EndYear, Role) VALUES
((SELECT $node_id FROM Designers WHERE DesignerID=1),  (SELECT $node_id FROM Brands WHERE BrandID=1),  1996, 2009, N'Креативный директор'),
((SELECT $node_id FROM Designers WHERE DesignerID=2),  (SELECT $node_id FROM Brands WHERE BrandID=2),  1991, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=3),  (SELECT $node_id FROM Brands WHERE BrandID=3),  1990, NULL, N'Креативный директор'),
((SELECT $node_id FROM Designers WHERE DesignerID=4),  (SELECT $node_id FROM Brands WHERE BrandID=4),  1994, 2001, N'Со-основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=5),  (SELECT $node_id FROM Brands WHERE BrandID=4),  1994, 2001, N'Со-основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=6),  (SELECT $node_id FROM Brands WHERE BrandID=5),  1969, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=7),  (SELECT $node_id FROM Brands WHERE BrandID=6),  1981, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=8),  (SELECT $node_id FROM Brands WHERE BrandID=7),  1970, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=9),  (SELECT $node_id FROM Brands WHERE BrandID=8),  1992, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=10), (SELECT $node_id FROM Brands WHERE BrandID=9),  1999, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=11), (SELECT $node_id FROM Brands WHERE BrandID=10), 2000, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=12), (SELECT $node_id FROM Brands WHERE BrandID=11), 1994, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=13), (SELECT $node_id FROM Brands WHERE BrandID=13), 1990, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=14), (SELECT $node_id FROM Brands WHERE BrandID=14), 1996, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=15), (SELECT $node_id FROM Brands WHERE BrandID=15), 1984, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=16), (SELECT $node_id FROM Brands WHERE BrandID=16), 1997, 2013, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=17), (SELECT $node_id FROM Brands WHERE BrandID=17), 2001, NULL, N'Основатель'),
((SELECT $node_id FROM Designers WHERE DesignerID=16), (SELECT $node_id FROM Brands WHERE BrandID=6),  1990, 1996, N'Менеджер / Ассистент');

INSERT INTO Released ($from_id, $to_id, ReleaseDate, NumberOfLooks, IsArchived) VALUES
((SELECT $node_id FROM Brands WHERE BrandID=1),  (SELECT $node_id FROM Collections WHERE CollectionID=1),  '2002-03-15', 38, 1),
((SELECT $node_id FROM Brands WHERE BrandID=1),  (SELECT $node_id FROM Collections WHERE CollectionID=2),  '2003-10-12', 42, 1),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Collections WHERE CollectionID=3),  '2002-10-08', 36, 1),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Collections WHERE CollectionID=4),  '2003-10-04', 40, 1),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Collections WHERE CollectionID=5),  '2004-03-08', 45, 1),
((SELECT $node_id FROM Brands WHERE BrandID=4),  (SELECT $node_id FROM Collections WHERE CollectionID=6),  '1996-10-20', 30, 1),
((SELECT $node_id FROM Brands WHERE BrandID=5),  (SELECT $node_id FROM Collections WHERE CollectionID=7),  '1996-10-12', 50, 1),
((SELECT $node_id FROM Brands WHERE BrandID=6),  (SELECT $node_id FROM Collections WHERE CollectionID=8),  '1981-10-04', 48, 1),
((SELECT $node_id FROM Brands WHERE BrandID=7),  (SELECT $node_id FROM Collections WHERE CollectionID=9),  '1992-10-10', 55, 0),
((SELECT $node_id FROM Brands WHERE BrandID=8),  (SELECT $node_id FROM Collections WHERE CollectionID=10), '1999-10-15', 42, 1),
((SELECT $node_id FROM Brands WHERE BrandID=9),  (SELECT $node_id FROM Collections WHERE CollectionID=11), '2010-03-08', 38, 0),
((SELECT $node_id FROM Brands WHERE BrandID=10), (SELECT $node_id FROM Collections WHERE CollectionID=12), '2001-03-01', 32, 1);

INSERT INTO BasedIn ($from_id, $to_id, SinceYear, IsHeadquarter) VALUES
((SELECT $node_id FROM Brands WHERE BrandID=1),  (SELECT $node_id FROM Cities WHERE CityID=1),  1996, 1),
((SELECT $node_id FROM Brands WHERE BrandID=2),  (SELECT $node_id FROM Cities WHERE CityID=1),  1991, 1),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Cities WHERE CityID=1),  1990, 1),
((SELECT $node_id FROM Brands WHERE BrandID=4),  (SELECT $node_id FROM Cities WHERE CityID=1),  1994, 1),
((SELECT $node_id FROM Brands WHERE BrandID=5),  (SELECT $node_id FROM Cities WHERE CityID=1),  1969, 1),
((SELECT $node_id FROM Brands WHERE BrandID=5),  (SELECT $node_id FROM Cities WHERE CityID=2),  1981, 0),
((SELECT $node_id FROM Brands WHERE BrandID=6),  (SELECT $node_id FROM Cities WHERE CityID=1),  1972, 1),
((SELECT $node_id FROM Brands WHERE BrandID=6),  (SELECT $node_id FROM Cities WHERE CityID=2),  1981, 0),
((SELECT $node_id FROM Brands WHERE BrandID=7),  (SELECT $node_id FROM Cities WHERE CityID=1),  1970, 1),
((SELECT $node_id FROM Brands WHERE BrandID=8),  (SELECT $node_id FROM Cities WHERE CityID=2),  1992, 0),
((SELECT $node_id FROM Brands WHERE BrandID=9),  (SELECT $node_id FROM Cities WHERE CityID=1),  1999, 1),
((SELECT $node_id FROM Brands WHERE BrandID=10), (SELECT $node_id FROM Cities WHERE CityID=1),  2000, 1),
((SELECT $node_id FROM Brands WHERE BrandID=11), (SELECT $node_id FROM Cities WHERE CityID=1),  1994, 1),
((SELECT $node_id FROM Brands WHERE BrandID=12), (SELECT $node_id FROM Cities WHERE CityID=1),  1993, 1);

INSERT INTO InspiredBy ($from_id, $to_id, InspirationYear, InfluenceLevel, [Description]) VALUES
((SELECT $node_id FROM Brands WHERE BrandID=1),  (SELECT $node_id FROM Brands WHERE BrandID=3),  2002, 8, N'Гранж- и панк-эстетика'),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Brands WHERE BrandID=5),  1990, 9, N'Авангардный подход и анти-мода'),
((SELECT $node_id FROM Brands WHERE BrandID=8),  (SELECT $node_id FROM Brands WHERE BrandID=5),  1992, 10, N'Прямое наследие линии CDG'),
((SELECT $node_id FROM Brands WHERE BrandID=9),  (SELECT $node_id FROM Brands WHERE BrandID=5),  1999, 9, N'Опыт работы Чисо Абэ в CDG'),
((SELECT $node_id FROM Brands WHERE BrandID=9),  (SELECT $node_id FROM Brands WHERE BrandID=8),  1999, 7, N'Концептуальный подход Junya'),
((SELECT $node_id FROM Brands WHERE BrandID=4),  (SELECT $node_id FROM Brands WHERE BrandID=5),  1994, 6, N'Деконструкция формы'),
((SELECT $node_id FROM Brands WHERE BrandID=11), (SELECT $node_id FROM Brands WHERE BrandID=12), 1994, 7, N'Сцена Урахарадзюку'),
((SELECT $node_id FROM Brands WHERE BrandID=12), (SELECT $node_id FROM Brands WHERE BrandID=3),  1993, 6, N'Urahara movement'),
((SELECT $node_id FROM Brands WHERE BrandID=2),  (SELECT $node_id FROM Brands WHERE BrandID=6),  1991, 5, N'Чёрная палитра, силуэт'),
((SELECT $node_id FROM Brands WHERE BrandID=10), (SELECT $node_id FROM Brands WHERE BrandID=7),  2000, 4, N'Подход к материалам и крафту'),
((SELECT $node_id FROM Brands WHERE BrandID=12), (SELECT $node_id FROM Brands WHERE BrandID=13), 1993, 10, N'Концепция лимитированного тиража'),
((SELECT $node_id FROM Brands WHERE BrandID=3),  (SELECT $node_id FROM Brands WHERE BrandID=13), 1990, 8,  N'Панк-DIY подход Фудзивары'),
((SELECT $node_id FROM Brands WHERE BrandID=1),  (SELECT $node_id FROM Brands WHERE BrandID=15), 1996, 7,  N'Использование музыкальной графики'),
((SELECT $node_id FROM Brands WHERE BrandID=14), (SELECT $node_id FROM Brands WHERE BrandID=11), 1996, 9,  N'Байкерская и милитари культура');

INSERT INTO Mentored ($from_id, $to_id, StartYear, YearsCount) VALUES
((SELECT $node_id FROM Designers WHERE DesignerID=6),  (SELECT $node_id FROM Designers WHERE DesignerID=9),  1984, 8),
((SELECT $node_id FROM Designers WHERE DesignerID=6),  (SELECT $node_id FROM Designers WHERE DesignerID=10), 1990, 9),
((SELECT $node_id FROM Designers WHERE DesignerID=9),  (SELECT $node_id FROM Designers WHERE DesignerID=10), 1992, 7),
((SELECT $node_id FROM Designers WHERE DesignerID=3),  (SELECT $node_id FROM Designers WHERE DesignerID=1),  1995, 1),
((SELECT $node_id FROM Designers WHERE DesignerID=8),  (SELECT $node_id FROM Designers WHERE DesignerID=11), 1995, 5),
((SELECT $node_id FROM Designers WHERE DesignerID=7),  (SELECT $node_id FROM Designers WHERE DesignerID=2),  1985, 6),
((SELECT $node_id FROM Designers WHERE DesignerID=6),  (SELECT $node_id FROM Designers WHERE DesignerID=8),  1970, 5),
((SELECT $node_id FROM Designers WHERE DesignerID=3),  (SELECT $node_id FROM Designers WHERE DesignerID=12), 1992, 2),
((SELECT $node_id FROM Designers WHERE DesignerID=8),  (SELECT $node_id FROM Designers WHERE DesignerID=10), 1989, 3),
((SELECT $node_id FROM Designers WHERE DesignerID=7),  (SELECT $node_id FROM Designers WHERE DesignerID=11), 1996, 2),
((SELECT $node_id FROM Designers WHERE DesignerID=13), (SELECT $node_id FROM Designers WHERE DesignerID=12), 1990, 5),
((SELECT $node_id FROM Designers WHERE DesignerID=13), (SELECT $node_id FROM Designers WHERE DesignerID=3),  1989, 4);
GO


-- ==========================================
-- ПУНКТ 8. VIEWS ДЛЯ ЭКСПОРТА
-- ==========================================

IF OBJECT_ID('vw_AllNodes')  IS NOT NULL DROP VIEW vw_AllNodes;
IF OBJECT_ID('vw_AllEdges')  IS NOT NULL DROP VIEW vw_AllEdges;
GO

CREATE VIEW vw_AllNodes AS
SELECT N'B_' + CAST(BrandID AS NVARCHAR(10))    AS Id, BrandName AS Name, N'Brand'      AS NodeType FROM Brands
UNION ALL
SELECT N'D_' + CAST(DesignerID AS NVARCHAR(10)), FullName,                    N'Designer'   FROM Designers
UNION ALL
SELECT N'C_' + CAST(CollectionID AS NVARCHAR(10)), CollectionName,            N'Collection' FROM Collections
UNION ALL
SELECT N'T_' + CAST(CityID AS NVARCHAR(10)),    CityName,                     N'City'       FROM Cities;
GO

CREATE VIEW vw_AllEdges AS
SELECT  N'D_' + CAST(d.DesignerID AS NVARCHAR(10)) AS Source,
        N'B_' + CAST(b.BrandID    AS NVARCHAR(10)) AS Target,
        N'WorksFor'                                AS EdgeType,
        1                                          AS Weight
FROM Designers d, WorksFor wf, Brands b
WHERE MATCH (d-(wf)->b)
UNION ALL
SELECT  N'B_' + CAST(b.BrandID      AS NVARCHAR(10)),
        N'C_' + CAST(c.CollectionID AS NVARCHAR(10)),
        N'Released', 1
FROM Brands b, Released r, Collections c WHERE MATCH (b-(r)->c)
UNION ALL
SELECT  N'B_' + CAST(b.BrandID AS NVARCHAR(10)),
        N'T_' + CAST(ci.CityID AS NVARCHAR(10)),
        N'BasedIn', 1
FROM Brands b, BasedIn bi, Cities ci WHERE MATCH (b-(bi)->ci)
UNION ALL
SELECT  N'B_' + CAST(b1.BrandID AS NVARCHAR(10)),
        N'B_' + CAST(b2.BrandID AS NVARCHAR(10)),
        N'InspiredBy', ib.InfluenceLevel
FROM Brands b1, InspiredBy ib, Brands b2 WHERE MATCH (b1-(ib)->b2)
UNION ALL
SELECT  N'D_' + CAST(d1.DesignerID AS NVARCHAR(10)),
        N'D_' + CAST(d2.DesignerID AS NVARCHAR(10)),
        N'Mentored', 1
FROM Designers d1, Mentored mt, Designers d2 WHERE MATCH (d1-(mt)->d2);
GO