-- Put debug functions in this here "namespace" (table)
-- Collect logs in this list.
dbg = {
    max_logs = 12,
    logs = {},
    log = function(self, s)
        add(self.logs, s)
	    printh(s, "dbg.log")
    end,
    print = function(self)
        local out_str = ""
        for l in all(self.logs) do
            out_str = out_str..l.."\n"
        end
        print(out_str)
        -- remove old logs
        if count(self.logs) > self.max_logs then
            local remove_count = count(self.logs) - self.max_logs 
            for i=1,remove_count do
                del(self.logs, self.logs[1])
            end
        end
    end
}
