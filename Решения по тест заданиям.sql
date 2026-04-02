# Создаю базу данных FP, таблицу users, затем импортирую данные в эту таблицу.
CREATE DATABASE FP;
CREATE TABLE users (
date DATE, 
user_id VARCHAR (50),
view_adverts INT);

 SELECT * FROM users;


# Задание 1 Информация о пользователях, посетивших наше приложение в ноябре. Чему равен MAU продукта? 
# Oтвет: 7639 

SELECT COUNT(DISTINCT user_id) AS MAU
FROM users
WHERE MONTH (date)=11; 



# Задание 2 Посчитайте, чему будет равен DAU?
# Ответ: 560

SELECT AVG(DAU) AS average_DAU
FROM (
    SELECT date(date) AS activity_date,
    COUNT(DISTINCT user_id) AS DAU
    FROM users
    GROUP BY activity_date
) AS daily_counts;



# Задание 3 Посчитайте, чему будет равен retention первого дня у пользователей, пришедших в продукт 1 ноября 
# Ответ: 26.6

SELECT 
    (COUNT(DISTINCT r.user_id) / COUNT(DISTINCT n.user_id)) * 100 AS day_1_retention
FROM 
    -- 1. Находим новых пользователей 1 ноября
    (SELECT DISTINCT user_id 
     FROM users 
     WHERE date = '2023-11-01') AS n
LEFT JOIN 
    -- 2. Проверяем их наличие 2 ноября
    (SELECT DISTINCT user_id 
     FROM users 
     WHERE date = '2023-11-02') AS r 
ON n.user_id = r.user_id;



# Задание 5  Посчитайте пользовательскую конверсию в просмотр объявления за ноябрь? (в пользователях).
# Ответ: 46,31

SELECT 
    (COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) / COUNT(DISTINCT user_id)) * 100 AS user_conversion_percent
FROM users
WHERE MONTH(date) = 11;



# Задание 6 Используя информацию из вкладки "Данные об аудитории", посчитайте среднее количество просмотренных объявлений на пользователя в ноябре
# Ответ: 2,86 

SELECT 
    SUM(view_adverts) / COUNT(DISTINCT user_id) AS avg_adverts_per_user
FROM users
WHERE MONTH(date) = 11;

# Задание 7 Мы провели опрос среди 2000 пользователей. Из них 500 «критики», 1200 «сторонники» и 300 «нейтралы». Посчитайте, чему будет равен NPS 
# NPS (Net Promoter Score) — это метрика, которая измеряет лояльность пользователей к компании или продукту и делит их на три группы: Сторонники (Promoters) , Нейтралы (Passives),  Критики (Detractors).
# NPS высчитывается как (% сторонников - % критиков).
# Сторонники (Promoters): (1200/2000)*100=60 %
# Критики (Detractors):   (500/2000)*100=25 %
# Нейтралы (Passives): (300/2000)*100=15 %
# NPS (Net Promoter Score):  60-25=35 %
# Ответ: 35 %

