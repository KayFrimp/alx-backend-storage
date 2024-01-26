-- SQL script that creates a stored procedure ComputeAverageWeightedScoreForUser
-- that computes and store the average weighted score for a student.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id_param INT)
BEGIN
    DECLARE project_id_var INT;
    DECLARE score_var FLOAT;
    DECLARE weighted_score_var FLOAT;
    DECLARE total_weight_var INT;
    
    -- Cursor to fetch corrections for the specified user
    DECLARE correction_cursor CURSOR FOR
        SELECT project_id, score
        FROM corrections
        WHERE user_id = user_id_param;
    
    -- Declare continue handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET @done = TRUE;
    
    -- Fetch total weight for the specified user
    SELECT SUM(weight) INTO total_weight_var
    FROM projects
    WHERE id IN (SELECT project_id FROM corrections WHERE user_id = user_id_param);
    
    -- Loop through corrections for the specified user
    OPEN correction_cursor;
    correction_loop: LOOP
        FETCH correction_cursor INTO project_id_var, score_var;
        
        IF @done THEN
            LEAVE correction_loop;
        END IF;
        
        -- Calculate weighted score
        SET weighted_score_var = score_var * (SELECT weight FROM projects WHERE id = project_id_var);
        
        -- Update user's average score
        UPDATE users
        SET average_score = (average_score + weighted_score_var) / total_weight_var
        WHERE id = user_id_param;
    END LOOP;
    CLOSE correction_cursor;
    
END //

DELIMITER ;
