// Vendor
import { addColors, createLogger, format, transports } from "winston";

addColors({
  debug: "bold green",
  info: "bold green",
  warn: "bold yellow",
  error: "bold red",
  fatal: "bold red",
});

export const logger = createLogger({
  level: "info",
  levels: {
    debug: 4,
    info: 3,
    warn: 2,
    error: 1,
    fatal: 0,
  },
});

logger.add(
  new transports.Console({
    format: format.combine(
      format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
      format.colorize(),
      format.printf(
        ({ level, message, timestamp }) => `[${timestamp}] ${level}: ${message}`
      )
    ),
  })
);
