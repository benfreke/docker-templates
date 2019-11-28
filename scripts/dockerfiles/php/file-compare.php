<?php

/**
 * Class CheckFiles
 */
class CheckFiles
{
    private const ARRAY_KEY_FILENAME = 'CHECK_FILES_FILENAME';

    private $directoryToCheck = '';

    /**
     * CheckFiles constructor.
     *
     * @param string|null $defaultDirectory absolute patah to directory containing your .env files
     */
    public function __construct(?string $defaultDirectory = '/var/www/html')
    {
        if (empty($defaultDirectory)) {
            $defaultDirectory = __DIR__;
        }
        $this->setDefaultDirectory($defaultDirectory);
    }

    /**
     *
     */
    public function checkFiles()
    {
        $result = [];
        $result[] = $this->checkArrays($this->getEnv(), $this->getEnvExample());
        $result[] = $this->checkArrays($this->getEnvExample(), $this->getEnv());

        // If we have a testing file, check that against the example file
        if (file_exists($this->directoryToCheck . '/' . '.env.testing')) {
            $result[] = [];
        }

        // Clean out empty values
        $result = array_filter($result);

        // If we have any results left, we had some errors.
        if (empty($result)) {
            // No errors. Exit safely
            exit(0);
        }

        fwrite(STDERR, "Errors discovered. Exiting" . PHP_EOL . PHP_EOL);

        // echo each error to stderr
        foreach ($result as $errorString) {
            fwrite(STDERR, $errorString . PHP_EOL);
        }

        // Always exit 1 to ensure scripts stop safely
        exit(1);
    }

    /**
     * @param array $first
     * @param array $second
     *
     * @return string|null
     */
    private function checkArrays(array $first, array $second): ?string
    {
        $result = null;
        $arrayDifference = array_diff_key($first, $second);
        if (!empty($arrayDifference)) {
            $result = "{$first[static::ARRAY_KEY_FILENAME]} has keys that {$second[static::ARRAY_KEY_FILENAME]} does not." . PHP_EOL;
            $result .= "Offending keys:" . PHP_EOL;
            foreach ($arrayDifference as $key => $value) {
                $result .= $key . PHP_EOL;
            }
        }
        return $result;
    }

    /**
     * @param string $directoryToSet
     *
     * @return $this
     */
    private function setDefaultDirectory(string $directoryToSet): self
    {
        $this->directoryToCheck = $directoryToSet;
        return $this;
    }

    /**
     * Adds the .env file to the files to check
     *
     * @return array
     */
    private function getEnv(): array
    {
        return $this->getFileAsArray('.env');
    }

    /**
     * @return array
     */
    private function getEnvExample()
    {
        return $this->getFileAsArray('.env.example');
    }

    /**
     *
     * @return array
     */
    private function getEnvTesting()
    {
        $this->filesToCheck[] = $this->getFileAsArray('.env.testing');
    }

    /**
     * Get a ini file and return the values as an array
     *
     * @param string $fileName
     *
     * @return array
     */
    private function getFileAsArray(string $fileName): array
    {
        $fileAsArray = parse_ini_file($this->directoryToCheck . '/' . $fileName);
        if (!$fileAsArray) {
            return [];
        }
        $fileAsArray[static::ARRAY_KEY_FILENAME] = $fileName;
        return $fileAsArray;
    }
}

$myFileChecker = new CheckFiles();
$myFileChecker->checkFiles();


