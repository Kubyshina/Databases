-- Процедура: применить скидку (например, при использовании промокода)
DROP PROCEDURE IF EXISTS skyscanner.promo_price;
DELIMITER //
CREATE PROCEDURE skyscanner.promo_price(IN ticket_id  BIGINT, IN percent FLOAT)
BEGIN
    UPDATE skyscanner.flights_tickets SET price = (price * (1 - percent)) WHERE id = ticket_id;
END//

DELIMITER ;

CALL skyscanner.promo_price(1, 0.10); 

SELECT * FROM skyscanner.flights_tickets;