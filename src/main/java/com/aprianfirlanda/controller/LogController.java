package com.aprianfirlanda.controller;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/logs")
public class LogController {

    private void logBuilder(String level, String msg) {
        switch (level.toUpperCase()) {
            case "TRACE" -> log.trace(msg);
            case "DEBUG" -> log.debug(msg);
            case "INFO" -> log.info(msg);
            case "WARN" -> log.warn(msg);
            case "ERROR" -> log.error(msg);
            default -> log.info("[unknown-level:{}] {}", level, msg);
        }
    }

    @GetMapping("/{level}")
    public String logByPath(
            @PathVariable String level,
            @RequestParam(defaultValue = "Ping") String message
    ) {
        String msg = "[manual] " + message;
        logBuilder(level, msg);

        return "OK";
    }

    @GetMapping("/exception")
    public String logException(
            @RequestParam(defaultValue = "Simulated failure") String message
    ) {
        try {
            throw new IllegalStateException(message);
        } catch (Exception e) {
            log.error("An exception occurred", e);
        } finally {
            MDC.clear();
        }
        return "Exception logged";
    }

    @GetMapping("/bulk")
    public String logBulk(
            @RequestParam(defaultValue = "INFO") String level,
            @RequestParam(defaultValue = "10") int count,
            @RequestParam(defaultValue = "Bulk message") String message,
            @RequestParam(defaultValue = "0") long sleepMs
    ) throws InterruptedException {
        for (int i = 1; i <= count; i++) {
            String msg = "[bulk " + i + "/" + count + "] " + message;
            logBuilder(level, msg);
            if (sleepMs > 0) Thread.sleep(sleepMs);
        }
        return "Bulk logged: " + count;
    }

    @GetMapping("/random")
    public String random() {
        String[] lvls = {"TRACE", "DEBUG", "INFO", "WARN", "ERROR"};
        String lvl = lvls[(int) (Math.random() * lvls.length)];
        logBuilder(lvl, "Random log");

        return "OK";
    }
}
