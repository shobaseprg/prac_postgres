CREATE OR REPLACE FUNCTION update_family_finances_total()
RETURNS TRIGGER AS $$
BEGIN
    -- データを集計
    UPDATE public.family_finances_total
    SET
        sum = (SELECT SUM(deposits - amount) FROM public.family_finances WHERE title = NEW.title),
        avg = (SELECT AVG(deposits - amount) FROM public.family_finances WHERE title = NEW.title),
        max = (SELECT MAX(deposits - amount) FROM public.family_finances WHERE title = NEW.title),
        min = (SELECT MIN(deposits - amount) FROM public.family_finances WHERE title = NEW.title),
        count = (SELECT COUNT(*) FROM public.family_finances WHERE title = NEW.title)
    WHERE title = NEW.title;

    -- もし対応するレコードが存在しない場合は新規に挿入
    IF NOT FOUND THEN
        INSERT INTO public.family_finances_total (title, sum, avg, max, min, count)
        VALUES (NEW.title, NEW.deposits - NEW.amount, NEW.deposits - NEW.amount, NEW.deposits - NEW.amount, NEW.deposits - NEW.amount, 1);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ======================

CREATE TRIGGER update_family_finances_total_trigger
AFTER INSERT OR UPDATE ON public.family_finances
FOR EACH ROW
EXECUTE FUNCTION update_family_finances_total();
