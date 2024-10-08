-- see the number of identified words
SELECT count(*) FROM poems_word;

-- return the first three words form the table
SELECT * FROM poems_word LIMIT 3;

-- a number of words have incomplete translation in a form "see ..." referring to other translation source;
-- return the words with this incomplete translation:

SELECT * FROM poems_word WHERE eng_transl LIKE 'see %';

--  word_id |  word  |       eng_transl        |       rus_transl        
-- ---------+--------+-------------------------+-------------------------
--      139 | пэжыр  | see псалъафэ зэпыщӀахэр | см. псалъафэ зэпыщӀахэр
--      140 | махуэл | see псалъафэ зэпыщӀахэр | см. псалъафэ зэпыщӀахэр
--      551 | пэщыху | see псалъафэ зэпыщӀахэр | см. псалъафэ зэпыщӀахэр

-- return poems that have less than three identified words
-- the HAVING clause allows to filter results after the GROUP BY operation;

SELECT poem_id, COUNT(word_id) AS total_words
FROM poems_poem_words
GROUP BY poem_id
HAVING COUNT(word_id) < 3
ORDER BY total_words;

--  poem_id | total_words 
-- ---------+-------------
--       24 |           1
--       79 |           2

-- The HAVING Statement
-- use HAVING to filter on aggregated fields;
-- HAVING is the aggregated equivalent to WHERE.
-- The WHERE keyword filters individual records, HAVING filters aggregations.

-- select words starting with letter "р";
-- the only words that start with this letter are those that were borrowed from other languages such as Russian;
-- consequently, there is a limited number of these words in Kabardian language;

SELECT * FROM poems_word WHERE word LIKE 'р%';

--  word_id | word | eng_transl | rus_transl 
-- ---------+------+------------+------------
--      691 | розэ | rose       | роза


-- select words starting with letter "р" together with poems these words occur in

SELECT 
    w.word_id, w.word, w.eng_transl,
    p.poem_id, p.title, p.author
FROM poems_poem p
JOIN poems_poem_words pw ON pw.poem_id = p.poem_id
JOIN poems_word w ON w.word_id = pw.word_id
WHERE w.word LIKE 'р%';

--  word_id | word | eng_transl | poem_id |        title         |    author    
-- ---------+------+------------+---------+----------------------+--------------
--      691 | розэ | rose       |      67 | Удз гъэгъа щхъуантIэ | Бицу Анатолэ


-- select all words with адыгэ/шэрджэс https://kbd.wiktionary.org/wiki/%D0%B0%D0%B4%D1%8B%D0%B3%D1%8D

SELECT 
    w.word, w.eng_transl, p.poem_id, p.title
FROM poems_poem p
JOIN poems_poem_words pw ON pw.poem_id = p.poem_id
JOIN poems_word w ON w.word_id = pw.word_id
WHERE w.word LIKE '%адыгэ%' OR w.word LIKE'%шэрджэс%';

--    word   |                                                        eng_transl                                                         | poem_id |             title             
-- ----------+---------------------------------------------------------------------------------------------------------------------------+---------+-------------------------------
--  адыгэбзэ | 1. Adyghe language (of the Kabardians, Cherkesses and Adygeans (Circassians)) 2. Kabardino-Cherkess (Circassian) language |       2 | Мэбзэрабзэ бзур, мэбзэрабзэ
--  адыгэ    | Adyghe (name given to themselves by the Adygeans, Kabardians, and Cherkesses (Circassians).                               |      22 | Адыгэ уанащIэхэр
--  адыгэш   | the Kabardian (Circassian) breed of horses (both for riding and as a pack-horse)                                          |      22 | Адыгэ уанащIэхэр
--  адыгэ    | Adyghe (name given to themselves by the Adygeans, Kabardians, and Cherkesses (Circassians).                               |      32 | Ей, дунеижьурэ дыгъужь нэщIа…
--  шэрджэс  | 1. Cherkess (man, woman, nation) 2. Cherkess people (a common name for all Adyghe peoples)                                |      91 | Анэдэлъхубзэ

-- DISTINCT only returns unique rows in a result set - and row will only appear once
-- DISTINCT ON limits duplicate remova; to a set of columns: 

SELECT DISTINCT ON (w.word) w.word, w.eng_transl, p.poem_id, p.title
FROM poems_poem p
JOIN poems_poem_words pw ON pw.poem_id = p.poem_id
JOIN poems_word w ON w.word_id = pw.word_id
WHERE w.word LIKE '%адыгэ%' OR w.word LIKE'%шэрджэс%';

--    word   |                                                        eng_transl                                                         | poem_id |            title            
-- ----------+---------------------------------------------------------------------------------------------------------------------------+---------+-----------------------------
--  адыгэ    | Adyghe (name given to themselves by the Adygeans, Kabardians, and Cherkesses (Circassians).                               |      22 | Адыгэ уанащIэхэр
--  адыгэбзэ | 1. Adyghe language (of the Kabardians, Cherkesses and Adygeans (Circassians)) 2. Kabardino-Cherkess (Circassian) language |       2 | Мэбзэрабзэ бзур, мэбзэрабзэ
--  адыгэш   | the Kabardian (Circassian) breed of horses (both for riding and as a pack-horse)                                          |      22 | Адыгэ уанащIэхэр
--  шэрджэс  | 1. Cherkess (man, woman, nation) 2. Cherkess people (a common name for all Adyghe peoples)                                |      91 | Анэдэлъхубзэ



-- select all words that contain "кхъу" letter which consist of four symbols to represent a single sound in Kabardian
-- for sound see/listen to: https://kkumyk.github.io/circassian-language/kabardian-alphabet.html

SELECT word, eng_transl FROM poems_word WHERE word LIKE '%кхъу%';

--   word  |          eng_transl           
-- --------+-------------------------------
--  кхъухь | ship, steamer, sailing vessel


-- Similar to German, Kabardian is known for creating words from existing words resulting in some lengthy words such as: 
-- ЗЫКЪЫСХУКIУЭЦIЫГЪЭДЖЭРЭЗЫКIЫЖЫФЫНУТЭКЪЫМИ (couldn't get out)
-- https://www.youtube.com/watch?v=Te_2eA1t1dQ

-- find the top 10 longest words in the poems_word table
SELECT word, length(word) as word_length, eng_transl FROM poems_word ORDER BY word_length desc LIMIT 10;

--        word       | word_length |                                  eng_transl                                   
-- ------------------+-------------+-------------------------------------------------------------------------------
--  гъуэгугъэлъагъуэ |          16 | guide, escort, sb who shows the way
--  мастэкъуаншэ     |          12 | pin, safety pin, hatpin
--  гухэхъуэгъуэ     |          12 | happiness, joy, celebration
--  нэщхъеягъуэ      |          11 | trouble, disaster, catastrophe, calamity, tragedy, sorrow, grief, woe, sorrow
--  лъэужьыншэу      |          11 | without a trace
--  нэбэнэушэу       |          10 | sleepy, in one"s sleep; in a state of drowsiness
--  шындырхъуо       |          10 | lizard
--  тхьэрыкъуэ       |          10 | 1. dove, pigeon
--  къущхьэхъу       |          10 | mountain pasture
--  пцӏащхъуэ        |           9 | swallow




