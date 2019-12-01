<?php

/**
 * Class CheckFiles
 *
 * This class checks the provided .env files (if they exist) and ensures they have the same keys
 *
 * This should be called from a shall script with `set -e` for proper behaviour i.e. stop on error
 */
class CheckFiles
{
    /**
     * Static key used to allow nice messages in the output
     */
    private const ARRAY_KEY_FOR_FILENAME = 'CHECK_FILES_FILENAME';

    /**
     * @var string The absolute path to the directory containing files to check
     */
    private $directoryToCheck = '';

    /**
     * @var array The ini files to be compared
     */
    private $filesToCheck = [];

    /**
     * CheckFiles constructor.
     *
     * @param array $extraFilesToCheck An array of ini files, relative to defaultDirectory, to compare
     * @param string|null $defaultDirectory absolute patah to directory containing your .env files. Null means __DIR__
     */
    public function __construct(array $extraFilesToCheck = [], ?string $defaultDirectory = '/var/www/html')
    {
        // Ensure we always have a default directory
        if (empty($defaultDirectory)) {
            $defaultDirectory = __DIR__;
        }

        // Set up the defaults
        $this->setDefaultDirectory($defaultDirectory)
            ->addExtraFile('.env')
            ->addExtraFile('.env.example');

        // Add any extra files that we want to check
        foreach ($extraFilesToCheck as $extraFile) {
            $this->addExtraFile($extraFile);
        }
    }

    /**
     * Adds the given file to the array to be checked
     *
     * If the file doesn't exist, it will not be added
     *
     * @param string $fileToAdd
     *
     * @return $this
     */
    private function addExtraFile(string $fileToAdd): self
    {
        $pathToFile = $this->getFilePath($fileToAdd);

        // If the file doesn't exist, return early
        if (!file_exists($pathToFile)) {
            return $this;
        }
        $this->filesToCheck[] = $fileToAdd;
        return $this;
    }

    /**
     * Checks that keys match in the .env files
     */
    public function execute()
    {
        $result = [];

        // Loop through the array of ini files to check, and compare them all against each other
        $filesCount = count($this->filesToCheck);
        for ($i = 0; $i < $filesCount; $i++) {
            // Check forward if we can
            $localIndex = $i;
            while (++$localIndex < $filesCount) {
                $result[] = $this->checkArrays(
                    $this->getIniFile($this->filesToCheck[$i]),
                    $this->getIniFile($this->filesToCheck[$localIndex])
                );
            }

            // Check back if we can
            $localIndex = $i;
            while (--$localIndex >= 0) {
                $result[] = $this->checkArrays(
                    $this->getIniFile($this->filesToCheck[$i]),
                    $this->getIniFile($this->filesToCheck[$localIndex])
                );
            }
        }

        // Clean out empty values
        $result = array_filter($result);

        // If we have any results left, we had some errors.
        if (empty($result)) {
            // No errors. Exit safely
            exit(0);
        }

        // Write to stderr so the calling shell script exits properly
        fwrite(STDERR, "Errors discovered. Exiting" . PHP_EOL . PHP_EOL);

        // echo each error to stderr
        foreach ($result as $errorString) {
            fwrite(STDERR, $errorString . PHP_EOL);
        }

        // Always exit 1 to ensure scripts stop safely
        exit(1);
    }

    /**
     * @param string $fileName
     *
     * @return array parsed file or empty array
     */
    private function getIniFile(string $fileName): array
    {
        $pathToFile = $this->getFilePath($fileName);

        // Convert the file to an array
        $fileAsArray = parse_ini_file($pathToFile);
        if (!$fileAsArray) {
            return [];
        }
        // Add the filename
        $fileAsArray[static::ARRAY_KEY_FOR_FILENAME] = $fileName;
        return $fileAsArray;
    }

    /**
     * @param string $fileName
     *
     * @return string The absolute path to $fileName
     */
    private function getFilePath(string $fileName): string
    {
        return $this->directoryToCheck . '/' . $fileName;
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
            $result = "{$first[static::ARRAY_KEY_FOR_FILENAME]} has keys that {$second[static::ARRAY_KEY_FOR_FILENAME]} does not." . PHP_EOL;
            $result .= "Offending keys: " . implode(', ', array_keys($arrayDifference)) . PHP_EOL;
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
}

(new CheckFiles(['.env.testing']))->execute();
