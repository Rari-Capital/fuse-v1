// Environment
import dotenv from "dotenv";

// Vendor
import Joi from "joi";

export const validateEnvConfig = (configSchema: Joi.ObjectSchema<any>) => {
  const { error, value: validateEnvConfig } = configSchema.validate(
    dotenv.config().parsed,
    {
      allowUnknown: true,
    }
  );

  if (error) {
    throw new Error(`Config validation error: ${error.message}`);
  }

  return validateEnvConfig;
};
