CREATE TABLE test_10gb (
    id BIGINT,
    event_date DATE,
    event_time TIMESTAMP,
    value DOUBLE PRECISION,
    category CHAR(1)
);

CREATE INDEX idx_test_10gb_event_time ON test_10gb(event_time);

CREATE TABLE category_dict (
    category VARCHAR(1) PRIMARY KEY,
    category_full TEXT
);

-- Insert dictionary values
INSERT INTO category_dict VALUES
('A', 'A_full_description'),
('B', 'B_full_description'),
('C', 'C_full_description'),
('D', 'D_full_description');

CREATE INDEX idx_test_10gb_date_category ON test_10gb(event_date, category);


CREATE MATERIALIZED VIEW test_10gb_category_stats AS
SELECT 
    t.event_date,
    t.category,
    cd.category_full,
    SUM(t.value) AS total_value,
    COUNT(*) AS records_count
FROM 
    test_10gb t
LEFT JOIN 
    category_dict cd ON t.category = cd.category
GROUP BY 
    t.event_date, t.category, cd.category_full;
	