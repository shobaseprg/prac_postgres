-- データベースからトリガーを削除
DROP TRIGGER IF EXISTS update_family_finances_total_trigger ON public.family_finances;

-- 関数も削除する場合は以下を追加
DROP FUNCTION IF EXISTS update_family_finances_total();
