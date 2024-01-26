-- SQL script that creates stored procedure ComputeAverageWeightedScoreForUsers
-- that computes and store the average weighted score for all students
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE user_id_var INT;
    DECLARE project_id_var INT;
    DECLARE score_var FLOAT;
    DECLARE weighted_score_var FLOAT;
    DECLARE total_weight_var INT;
    
    -- Cursor to fetch corrections
    DECLARE correction_cursor CURSOR FOR
        SELECT user_id, project_id, score
        FROM corrections;
    
    -- Declare continue handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET @done = TRUE;
    
    -- Loop through corrections
    OPEN correction_cursor;
    correction_loop: LOOP
        FETCH correction_cursor INTO user_id_var, project_id_var, score_var;
        
        IF @done THEN
            LEAVE correction_loop;
        END IF;
        
        -- Calculate weighted score
        SELECT weight INTO total_weight_var FROM projects WHERE id = project_id_var;
        SET weighted_score_var = score_var * total_weight_var;
        
        -- Update user's average score
        UPDATE users
        SET average_score = (average_score + weighted_score_var) / (total_weight_var + 1)
        WHERE id = user_id_var;
    END LOOP;
    CLOSE correction_cursor;
    
END //

DELIMITER ;
